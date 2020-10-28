import numpy as np
import matplotlib.pyplot as plt
import uproot as up

plt.style.use("seaborn-paper")

if __name__ == "__main__":

    mu_dyn = []; mu_mcp = [];
    sigma_dyn = []; sigma_mcp = [];
    mu = []

    ff = up.open("/cvmfs/juno.ihep.ac.cn/centos7_amd64_gcc830/Pre-Release/J20v2r0-Pre0/data/Simulation/ElecSim/PmtData_Lpmt.root")
    isHam = ff["PmtData_Lpmt"].array("MCP_Hama")

    with open("./timeOffset.txt") as f:
        for lines in f.readlines():
            line = lines.strip("\n")
            data = line.split("\t")
            pmtid = int(data[0])
            mu.append(float(data[1]))
            if isHam[pmtid] == 0:  # mcp
                mu_mcp.append(float(data[1]))
                sigma_mcp.append(float(data[3]))
            else:
                mu_dyn.append(float(data[1]))
                sigma_dyn.append(float(data[3]))


    plt.hist(np.array(mu_dyn)-np.array(mu).mean(), bins=100, alpha=0.5, label="dynode")
    plt.hist(np.array(mu_mcp)-np.array(mu).mean(), bins=100, alpha=0.5, label="mcp")
    plt.legend()
    plt.xlabel("time offset/ns")
    plt.show()
