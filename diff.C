void diff(){
	double rela[17612];
	double relaN[17612];
  	double gain[17612];
	double gainN[17612];
  	double dr[17612];
	double drN[17612];
  	double tmp;
  	double tfs[17612];
	double tfsN[17612];
	double spem[17612];
	double spemN[17612];

	ifstream ifile;
     ifile.open("/afs/ihep.ac.cn/users/l/luoxj/Deconvolution_Sim/J20v2r0-Pre0_2nd/CalibPars_m.txt");
     //ifile.open("PmtPrtData_deconv.txt");
	for (int i = 0; i < 17612; i++) {
        ifile >> tmp >>rela[i]>>gain[i]>>tfs[i]>>dr[i]>>spem[i];//<< "\t" << mu[i] * 0.1 << "\t" << gain[i] << "\t" << tfs[i] << "\t" << dr[i] << "\t" << spem[i] << endl;
  }     ifile.close();

ifile.open("/cvmfs/juno.ihep.ac.cn/centos7_amd64_gcc830/Pre-Release/J20v2r0-Pre0/data/Calibration/PMTCalibSvc/data/PmtPrtData_deconv.txt");	
//ifile.open("../EasyIntegral2/Calib/all_CalibPars.txt");
//ifile.open("PmtPrtData_inte.txt");
//ifile.open("/afs/ihep.ac.cn/users/l/luoxj/Deconvolution_Sim/J20v2r0-Pre0_2nd/CalibPars_m.txt");
        for (int i = 0; i < 17612; i++) {
        ifile >> tmp >>relaN[i]>>gainN[i]>>tfsN[i]>>drN[i]>>spemN[i];//<< "\t" << mu[i] * 0.1 << "\t" << gain[i] << "\t" << tfs[i] << "\t" << dr[i] << "\t" << spem[i] << endl;
  }     ifile.close();

	TH1D* h = new TH1D("h", "DN",100,0,122000);
	TH1D* h2= new TH1D("h2","DN",100,0,122000);
	for(int i=0; i<17612; ++i) h->Fill(dr[i]);
	for(int i=0; i<17612; ++i) h2->Fill(drN[i]);
	
    TCanvas* c1= new TCanvas("c_DN","c_DN",800,600);
	h2->SetLineColor(kBlue);
	h->SetLineColor(kRed);
        h->Draw();
	h2->Draw("SAME");

	TH1D* h3 = new TH1D("h3","Relative Dectective Effeciency",200,0,0.2);
	TH1D* h4= new TH1D("h4","Relative Dectective Effeciency",200,0,0.2);
	for(int i=0; i<17612; ++i) h3->Fill(rela[i]);
	for(int i=0; i<17612; ++i) h4->Fill(relaN[i]);
    TCanvas* c2= new TCanvas("c_DE","c_DE",800,600);
	h4->SetLineColor(kBlue);
	h3->SetLineColor(kRed);
        h3->Draw();
	h4->Draw("SAME");
    
}
