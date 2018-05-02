module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },

    QA: {
      host: "localhost",
      port: 8545,
      network_id: "3" ,  // ROPSTEN
      // Options - gas, gasPrice, from
      from: "0x3a75ad8d08b388ca0f2afafb3c092aaf40ae72a6",
      gas: 4800000
    },

    PRODUCTION: {
      host: "localhost",
      port: 8545,
      network_id: "1"   // LIVE
      // Options - gas, gasPrice, from
    }
  }
};

