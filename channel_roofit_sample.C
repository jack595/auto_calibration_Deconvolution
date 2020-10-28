/*****************************************/
// Read the deltaT hist for all PMTs and fit partly
//to get the peak positions as time offsets.
//Authot: miaoyu@ihep.ac.cn
//Sep, 2019
/****************************************/


#include "RooWorkspace.h"
#include "RooRealVar.h"
#include "RooDataSet.h"
#include "RooDataHist.h"
#include "RooGaussian.h"
#include "RooFormulaVar.h"
#include "RooExponential.h"
#include "RooPlot.h"
#include "RooDecay.h"
#include "RooAddPdf.h"
#include "RooFitResult.h"
#include <iostream>
#include "TH1D.h"
#include "TF1.h"
#include "TString.h"
#include "TMath.h"
#include "TCanvas.h"
//#include <fstream.h>

//using namespace std;
using namespace RooFit;

#define PI 3.1415926
#define LS_R 17.7

void channel_roofit(){
     gStyle->SetOptFit(1101);

    const int m_totalPMT = 17612;
    double MIN_BIN = -200;
    double MAX_BIN = 800;
    int BIN_NUM = 1000;
    
    double sigma1 = 5;
    double sigma2 = 8;

    std::string dir = "./";
    std::string file = "time_corr.root";

    TH1D* onechannel;
    TF1* fit_func;
    TFile *pmt_file =TFile::Open((dir+file).c_str());

    //user's definition
    double deltaT[m_totalPMT];
    double deltaT_sigma[m_totalPMT];
    double deltaT_error[m_totalPMT];
    double sigma_error[m_totalPMT];
    double chi2NDF[m_totalPMT];
    double pmtType[m_totalPMT];
    double raylen[m_totalPMT];
    double darkRate[m_totalPMT];
    double realHit[m_totalPMT];
    TH1D* timeOffset = new TH1D("timeOffset","timeOffset",100,-50,50);
    
    // pmt type
    for(int i=0; i<17612; i++){ pmtType[i] = 0;}
    ifstream pmtdata;
    pmtdata.open("./pmtdata.txt");
    int tmp;
    string line;
    while(getline(pmtdata,line)){
        istringstream ss(line);
        ss >> tmp;
        pmtType[tmp] = 1;
    }


    for(int i=0; i<m_totalPMT; i++){
        cout << "Processing channel " << i << endl;
        TString chName = Form("ch%d_deltaT",i);
        onechannel = (TH1D*)pmt_file->Get(chName);
        if(!onechannel) cout << "Getting hist failed " << endl;
        
        Double_t peak = onechannel->GetMaximum();
        Int_t peak_pos = onechannel->GetMaximumBin();   
        double mean_init = peak_pos *(MAX_BIN-MIN_BIN)/BIN_NUM+MIN_BIN;  
        // if it is a hama_pmt
        // set integral range for different type pmts
        
        // declare variables
        RooRealVar fitx("fitx", "fitx", MIN_BIN, MAX_BIN);
        RooRealVar fitmean("fitmean","mean of gaussian", mean_init, mean_init-10, mean_init+10);
        RooRealVar fitsigma("fitsigma","sigma of gaussian", 5.0,0.1,20.0);
        RooRealVar fitA("fitA","A of gaussian",peak, peak-50, peak+50);
        if(pmtType[i]){
            fitx.setRange(mean_init-7,mean_init+3);
            fitsigma.setVal(2.0);
            fitsigma.setRange(0.1, 5.0);
        }
        if(!pmtType[i]){
            fitx.setRange(mean_init-10, mean_init+7);
            fitsigma.setVal(6.0);
            fitsigma.setRange(1.0, 15.);
        }
        // build gaussian p.d.f in terms of x, mean, sigma
        RooGenericPdf gauss("gauss model","fitA * TMath::Exp(-(fitx- fitmean)*(fitx - fitmean)/2/fitsigma/fitsigma)", RooArgSet(fitx,fitA,fitmean,fitsigma));


        // construct plot frame in 'x'
        RooPlot *xframe = fitx.frame(Title("Gaussian p.d.f"));

        // create a binned dataset that imports contents from TH1D and associates its contents to observable 'x'
        RooDataHist dh("dh", "dh", fitx, Import(*onechannel));
        dh.plotOn(xframe);

        // fit a Gaussian p.d.f to the data
        gauss.fitTo(dh);
        gauss.plotOn(xframe);
        gauss.paramOn(xframe, Layout(0.55));


        Double_t chi2 = xframe->chiSquare();
        cout <<"pmtID: " << i <<  "  chi2/ndf: " << chi2 << endl;

       // A d d   b o x   w i t h   d a t a   s t a t i s t i c s
       // -------------------------------------------------------  
       //dh.statOn(xframe,Layout(0.55,0.99,0.8)) ;

        TPaveText* pt2 = new TPaveText(.2,.8,.4,.9,"BRNDC");
        pt2->SetBorderSize(0);
        pt2->SetFillColor(0);
        pt2->SetTextAlign(12);
        pt2->SetTextSize(0.04);
        pt2->SetTextFont(42);
        TString Par5V2 = Form("%2.1f", xframe->chiSquare());
        TString Par52 = "#chi^{2}#/n.d.f = " + Par5V2;
        TText *text2 = pt2->AddText(Par52);
    

        // draw all frames on a canvas
        TCanvas* c = new TCanvas("roofit", "roofit", 800,600);
        xframe->Draw();
        pt2->Draw("SAME");
//        xframe->DrawClone();
//         TLegend *led = new TLegend(.4,.6,.89,.89);
//         led->AddEntry(fit_model,"total_fit","l");
//         led->Draw("SAME");

        //c->Print("RooFit.pdf");

        deltaT[i] = fitmean.getVal();
        deltaT_error[i] = fitmean.getError();
        deltaT_sigma[i] = fitsigma.getVal();
        sigma_error[i] = fitsigma.getError();
        chi2NDF[i] = chi2;
        //realHit[i] = non_sc;

        /***********************************/

        onechannel->Delete();
    }

    pmt_file->Close();
    
    ofstream out("timeOffset.txt");
    for(int i=0; i<m_totalPMT;i++){ out << i << "\t"<< deltaT[i] << "\t" <<deltaT_error[i] << "\t" 
        << deltaT_sigma[i] <<"\t" << sigma_error[i] << "\t" << chi2NDF[i]<< "\n";   }

    return;
}
