void script1()
{
  TFile* f = new TFile("./root/SPE_step1.root", "read");
  const int m_totalPMT = 17613;
  TH1D* m_Integral[m_totalPMT];
  for (int i = 0; i < m_totalPMT; i++) {
    ostringstream out1;
    out1 << "PMTID_" << i << "_Inte";
    m_Integral[i] = (TH1D*)f->Get(out1.str().c_str());
    m_Integral[i]->Rebin(5);
  }
  double binwidth = m_Integral[0]->GetBinWidth(1);

  ofstream output1;
  output1.open("Integral.txt");
  TCanvas* c = new TCanvas("c", "c", 800, 600);
  c->Print("SPE_step1_fit.pdf[");
  for (int i = 0; i < m_totalPMT; i++) {
    if (m_Integral[i]->GetEntries() > 0) {
      int minbin = 0;
      int minvalue = 1e8;

      for (int j = 0; j < 750. / binwidth; j++) {  // specified for J20v1r0-Pre0
        double tmp = m_Integral[i]->GetBinContent(j + 1);
        if (tmp <= minvalue) {
          minvalue = tmp;//这是在找0到750的极小值，而不是找极大值，因为噪声的峰很有可能会大于信号的峰，然后用这个极小值往外拉，即拟合，就可以比较好的得到高斯峰
          minbin = j;
        }
      }
      if (minbin * binwidth < 200) minbin = 200 / binwidth;//如果极小值在小于两百的地方出现，说明这个不是噪声和信号过渡而产生的极小值

      TF1* fun1 = new TF1("func1", "gaus", minbin * binwidth, 5000);
      m_Integral[i]->Fit(fun1, "RQ");  // specified for J20v1r0-Pre0
      if (fun1->GetChisquare() / fun1->GetNDF() > 4 || fun1->GetParameter(1) < 0) {
        c->cd();//把有问题的波形输出到pdf中，这样有利于检查一些个例，非常666
        m_Integral[i]->Draw("hist");
        fun1->Draw("same");
        c->Print("SPE_step1_fit.pdf");
      }

      output1 << i << ' ' << fun1->GetParameter(1) << ' ' << fun1->GetParameter(2) << endl;
      delete fun1;
    } else {
      output1 << i << ' ' << 0 << ' ' << 0 << endl;
    }
  }
  c->Print("SPE_step1_fit.pdf]");//可能用于关闭pdf，就像文件关闭一样
  output1.close();
}
