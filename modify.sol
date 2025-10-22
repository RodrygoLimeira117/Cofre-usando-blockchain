// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Cofre {
    address public dono;

    constructor() {
        dono = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == dono, "Apenas o dono pode executar esta funcao");
        _;
    }

    // Modificador para checar se o valor a ser transferido e valido e existe no saldo do contrato
    modifier checkTransferAmount(uint256 valor) {
        require(valor > 0, "O valor deve ser maior que zero");
        require(valor <= address(this).balance, "Saldo insuficiente no contrato");
        _;
    }

    // Função que permite ao contrato receber Ether explicitamente
    function depositar() public payable {
        // O valor e automaticamente adicionado ao saldo do contrato
    }

    // Função especial para receber Ether sem dados (fallback)
    receive() external payable {
        // Nenhuma lógica necessária
    }

    // Função para verificar o saldo do contrato (Retirado o onlyOwner para facilitar a leitura no explorer)
    function saldoDoContrato() public view returns (uint256) {
        return address(this).balance;
    }

    // Função de Saque Parcial (ou Total, se o valor for igual ao saldo)
    function transferirPara(address payable destinatario, uint256 valor) public onlyOwner checkTransferAmount(valor) {
        destinatario.transfer(valor);
    }
    
    // ===============================================
    // NOVA FUNÇÃO: SACAR TUDO (SACA O SALDO TOTAL)
    // ===============================================
    /// @notice Saca todo o saldo Ether do contrato para o dono (msg.sender).
    function sacarTudo() public onlyOwner {
        // 1. Obtém o saldo atual do contrato
        uint256 saldoTotal = address(this).balance;
        
        // 2. Garante que há algo para sacar
        require(saldoTotal > 0, "O contrato nao tem saldo para sacar.");

        // 3. Saca o saldo total para o dono
        // Utilizamos 'call' para ser mais robusto, mas 'transfer' também funciona
        (bool success, ) = dono.call{value: saldoTotal}("");
        require(success, "Falha na transferencia (saque).");
    }
    // ===============================================
}