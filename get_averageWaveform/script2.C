void script2()
{
  TFile* f = new TFile("./root/SPE.bck.root", "read");
  // TFile* f = new TFile("temp.root", "update");
  TH1D* m_meanWaveform[20000];
  TH1D* m_Counter;
  int m_totalPMT = 17613;
  int m_length = 1250;
  TH1* m_tempH;
  TH1D* m_SPERE[20000];
  TH1D* m_SPEIM[20000];
  for (int i = 0; i < m_totalPMT; i++) {
    ostringstream out1;
    out1 << "PMTID_" << i << "_SPERE";
    m_SPERE[i] = new TH1D(out1.str().c_str(), out1.str().c_str(), 400, 0, 400);  // specified for J16v2
    ostringstream out2;
    out2 << "PMTID_" << i << "_SPEIM";
    m_SPEIM[i] = new TH1D(out2.str().c_str(), out2.str().c_str(), 400, 0, 400);  // specified for J16v2
    ostringstream out3;
    out3 << "PMTID_" << i << "_MeanSpec";
    m_meanWaveform[i] = (TH1D*)f->Get(out3.str().c_str());
  }
  ostringstream out4;
  out4 << "PMT_Counter";
  m_Counter = (TH1D*)f->Get(out4.str().c_str());

  for (int i = 0; i < m_totalPMT; i++) {
    m_meanWaveform[i]->Scale(1. / m_Counter->GetBinContent(i + 1));
    delete TVirtualFFT::GetCurrentTransform();
    TVirtualFFT::SetTransform(0);
    m_tempH = m_meanWaveform[i]->FFT(m_tempH, "MAG");
    std::vector<double> re_full_vec(m_length);
    std::vector<double> im_full_vec(m_length);
    double* re_full = &re_full_vec.front();
    double* im_full = &im_full_vec.front();
    for (int j = 0; j < m_length; j++) {
      re_full[j] = 0;
      im_full[j] = 0;
    }
    TVirtualFFT* fft = TVirtualFFT::GetCurrentTransform();
    fft->GetPointsComplex(re_full, im_full);
    for (int j = 0; j < 400 && j < m_length; j++) {
      m_SPERE[i]->SetBinContent(j + 1, re_full[j]);
      m_SPEIM[i]->SetBinContent(j + 1, im_full[j]);
    }
  }
  TFile* outfile = new TFile("SPE.root", "recreate");
  outfile->cd();
  for (int i = 0; i < m_totalPMT; i++) {
    m_meanWaveform[i]->Write();
    m_SPERE[i]->Write();
    m_SPEIM[i]->Write();
  }
}
