// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FootballPlayerContract {
    address public owner; // Kulüp sahibi
    address public player; // Futbolcunun adresi
    address public paymentAddress; // Ödeme adresi

    uint public insuranceFee;
    uint public healthFee;
    uint public paymentLimit = 100 ether; // Ödeme limiti
    uint public lastSalaryPayment;

    // Sözleşme bilgileri için yapı
    struct ContractDetails {
        uint startDate;
        uint endDate;
        uint salary;
        uint bonus;
        uint transferFee;
        uint releaseFee;
        string behaviorRules;
        string sponsorshipRights;
        bool isActive; // Sözleşmenin aktif durumu
    }

    ContractDetails public contractDetails;

    // Performans verileri
    mapping(address => uint) public playerPerformances;

    // Olaylar
    event ContractSigned(address indexed player, uint startDate, uint endDate);
    event ContractUpdated(uint startDate, uint endDate, uint salary, uint bonus, uint transferFee, uint releaseFee, string behaviorRules, string sponsorshipRights);
    event SalaryPaid(uint amount, uint date);
    event TransferFeePaid(uint amount, uint date);
    event ReleaseFeePaid(uint amount, uint date);
    event ContractTerminated();
    event WarningIssued(string message);
    event BehaviorRated(uint rating, string comment);
    event BonusPaid(uint amount, uint date);
    event RefundIssued(uint amount, uint date);
    event ContractExtended(uint newEndDate);

    // Modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier onlyPlayer() {
        require(msg.sender == player, "Only the player can perform this action");
        _;
    }

    constructor(
        address _player, // Oyuncu adresi
        uint _startDate, // Başlama tarihi
        uint _endDate, // Bitiş tarihi
        uint _salary,  // Oyuncu maaşı
        uint _bonus, // Attığı gol ve şampiyonluk bonusu
        uint _transferFee, // Oyuncu transfer ücreti
        uint _releaseFee, // Serbest bırakma bedeli
        string memory _behaviorRules,
        string memory _sponsorshipRights
    ) {
        owner = msg.sender;
        player = _player;
        contractDetails = ContractDetails({
            startDate: _startDate,
            endDate: _endDate,
            salary: _salary,
            bonus: _bonus,
            transferFee: _transferFee,
            releaseFee: _releaseFee,
            behaviorRules: _behaviorRules,
            sponsorshipRights: _sponsorshipRights,
            isActive: true
        });

        emit ContractSigned(player, _startDate, _endDate);
    }

    // Sözleşme bilgilerini güncelle
    function updateContractDetails(
        uint _startDate, // Başlama tarihi
        uint _endDate, // Bitiş tarihi
        uint _salary, // Oyuncu maaşı
        uint _bonus, // Attığı gol ve şampiyonluk bonusu
        uint _transferFee, // Oyuncu transfer ücreti
        uint _releaseFee, // Serbest bırakma bedeli
        string memory _behaviorRules,
        string memory _sponsorshipRights
    ) external onlyOwner {
        contractDetails = ContractDetails({
            startDate: _startDate,
            endDate: _endDate,
            salary: _salary,
            bonus: _bonus,
            transferFee: _transferFee,
            releaseFee: _releaseFee,
            behaviorRules: _behaviorRules,
            sponsorshipRights: _sponsorshipRights,
            isActive: contractDetails.isActive
        });

        emit ContractUpdated(_startDate, _endDate, _salary, _bonus, _transferFee, _releaseFee, _behaviorRules, _sponsorshipRights);
    }

    // Maaş ödemesi yap
    function paySalary() external onlyOwner {
        require(contractDetails.isActive, "Contract is not active");
        require(address(this).balance >= contractDetails.salary, "Insufficient contract balance for salary payment");
        require(block.timestamp >= lastSalaryPayment + 30 days, "Salary already paid for this period"); // Aylık ödeme aralığı
        require(address(this).balance <= paymentLimit, "Contract balance exceeds payment limit");
        payable(player).transfer(contractDetails.salary);
        lastSalaryPayment = block.timestamp;
        emit SalaryPaid(contractDetails.salary, block.timestamp);
    }

    // Transfer ücreti ödemesi yap
    function payTransferFee() external onlyOwner {
        require(contractDetails.isActive, "Contract is not active");
        require(address(this).balance >= contractDetails.transferFee, "Insufficient contract balance for transfer fee payment");
        require(address(this).balance <= paymentLimit, "Contract balance exceeds payment limit");
        payable(owner).transfer(contractDetails.transferFee); // Transfer ücreti ödemesi kulüp sahibine yapılır
        emit TransferFeePaid(contractDetails.transferFee, block.timestamp);
    }

    // Serbest bırakma ücreti ödemesi yap
    function payReleaseFee() external onlyPlayer {
        require(contractDetails.isActive, "Contract is not active");
        require(address(this).balance >= contractDetails.releaseFee, "Insufficient contract balance for release fee payment");
        require(address(this).balance <= paymentLimit, "Contract balance exceeds payment limit");
        payable(owner).transfer(contractDetails.releaseFee); // Serbest bırakma ücreti ödemesi kulüp sahibine yapılır
        terminateContract(); // Ücret ödendiğinde sözleşme feshedilir
        emit ReleaseFeePaid(contractDetails.releaseFee, block.timestamp);
    }

    // Sigortalama ücretini ayarla
    function setInsuranceFee(uint _insuranceFee) external onlyOwner {
        insuranceFee = _insuranceFee;
    }

    // Sağlık ücretini ayarla
    function setHealthFee(uint _healthFee) external onlyOwner {
        healthFee = _healthFee;
    }

    // Sigortalama ücretini öde
    function payInsuranceFee() external onlyOwner {
        require(address(this).balance >= insuranceFee, "Insufficient contract balance for insurance fee payment");
        payable(owner).transfer(insuranceFee); // Ödeme kulüp sahibine yapılır
        emit TransferFeePaid(insuranceFee, block.timestamp);
    }

    // Sağlık ücretini öde
    function payHealthFee() external onlyOwner {
        require(address(this).balance >= healthFee, "Insufficient contract balance for health fee payment");
        payable(owner).transfer(healthFee); // Ödeme kulüp sahibine yapılır
        emit TransferFeePaid(healthFee, block.timestamp);
    }

    // Bonus ödemesi yap
    function payBonus() external onlyOwner {
        require(contractDetails.isActive, "Contract is not active");
        require(address(this).balance >= contractDetails.bonus, "Insufficient contract balance for bonus payment");
        payable(player).transfer(contractDetails.bonus);
        emit BonusPaid(contractDetails.bonus, block.timestamp);
    }

    // Performans güncelle
    function updatePerformance(address _player, uint _performanceScore) external onlyOwner {
        playerPerformances[_player] = _performanceScore;
        if (_performanceScore > 90) {
            uint bonus = 1 ether; // Örneğin 1 ETH bonus
            payable(_player).transfer(bonus);
            emit BonusPaid(bonus, block.timestamp);
        }
    }

    // Sözleşme süresini uzatma
    function extendContract(uint _newEndDate) external onlyOwner {
        require(_newEndDate > contractDetails.endDate, "New end date must be later than current end date");
        contractDetails.endDate = _newEndDate;
        emit ContractExtended(_newEndDate);
    }

    // İade fonksiyonu
    function refundPayment(uint _amount) external onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance for refund");
        payable(owner).transfer(_amount);
        emit RefundIssued(_amount, block.timestamp);
    }

    // Sözleşmeyi feshet
    function terminateContract() public {
        require(msg.sender == owner || msg.sender == player, "Only the owner or player can terminate the contract");
        contractDetails.isActive = false;
        emit ContractTerminated();
    }

    // İhtarname gönder
    function issueWarning(string memory _message) external onlyOwner {
        emit WarningIssued(_message);
    }

    // Davranış puanlama
    function rateBehavior(uint _rating, string memory _comment) external onlyOwner {
        // Davranış puanlama sistemine göre işlem yapılabilir
        emit BehaviorRated(_rating, _comment);
    }

    // Sözleşme bilgilerini görüntüle
    function getContractDetails() external view returns (
        uint startDate,
        uint endDate,
        uint salary,
        uint bonus,
        uint transferFee,
        uint releaseFee,
        string memory behaviorRules,
        string memory sponsorshipRights,
        bool isActive
    ) {
        return (
            contractDetails.startDate,
            contractDetails.endDate,
            contractDetails.salary,
            contractDetails.bonus,
            contractDetails.transferFee,
            contractDetails.releaseFee,
            contractDetails.behaviorRules,
            contractDetails.sponsorshipRights,
            contractDetails.isActive
        );
    }

    // Sözleşmenin bakiyesini görüntüle
    function getContractBalance() external view returns (uint) {
        return address(this).balance;
    }
}
