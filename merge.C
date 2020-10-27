void merge()
{
  int i;
  double mu[17612];
  double gain[17612];
  double dr[17612];
  double timeoffset[17612];
  double tmp;
  ifstream file;
  // dr
  file.open("./charge_calib/get_MeanGain/CalibPars_dn.txt");
  while (file >> i >> dr[i])
    if (i == 17612) break;
  file.close();
  // mu
  file.open("./charge_calib/get_MeanGain/CalibPars_de.txt");
  while (file >> i >> mu[i] >> tmp >>tmp )
    if (i == 17612) break;
  file.close();
  // gain
  file.open("./PmtPrtData_deconv.txt");
  while (file >> i >> tmp >> gain[i] >> timeoffset[i]>> tmp >> tmp )
    if (i == 17612) break;
  file.close();
  // mean
  TFile* f = new TFile("./charge_calib/get_MeanGain/C14_calib0/step4/user_calibCorr.root", "read");
  TH1F* spe;
  double spem[17612];
  for (int i = 0; i < 17612; i++) {
    TString name = Form("ch%d_charge_spec", i);
    spe = (TH1F*)f->Get(name);
    spem[i] = spe->GetMean();
  }

  ofstream ofile;
  // ofile.open("CalibPars_decon.txt");
  ofile.open("CalibPars_m.txt");
  for (int i = 0; i < 17612; i++) {
    ofile << i << "\t" << mu[i] * 0.1 << "\t" << gain[i]<< "\t" << timeoffset[i] << "\t" << dr[i] << "\t" << spem[i] << endl;
  }
  ofile.close();
}
