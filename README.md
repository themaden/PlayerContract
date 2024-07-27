# Football Player Contract

Contract addreesss = 

Bu proje, bir futbol oyuncusunun sözleşme detaylarını yönetmek için Solidity kullanılarak yazılmış bir akıllı sözleşmedir. Sözleşme, maaş ödemeleri, transfer ücretleri, serbest bırakma ücretleri ve performans yönetimi gibi çeşitli futbolcu sözleşmesi özelliklerini içermektedir.

## Özellikler

- **Maaş Ödemesi:** Futbolcunun maaşını aylık olarak ödeyebilme.
- **Transfer Ücreti:** Kulüp sahibine transfer ücreti ödemesi yapabilme.
- **Serbest Bırakma Ücreti:** Futbolcunun serbest bırakılma ücreti ödeyebilmesi.
- **Sigorta ve Sağlık Ücretleri:** Sigorta ve sağlık ücretlerini ayarlama ve ödeme.
- **Bonus Ödemesi:** Futbolcunun performansına bağlı olarak bonus ödemesi yapabilme.
- **Performans Yönetimi:** Futbolcunun performansını güncelleyebilme.
- **Sözleşme Süresini Uzatma:** Sözleşme süresini uzatabilme.
- **İhtarname Gönderme:** Kulüp sahibi tarafından futbolcuya ihtarname gönderme.
- **Davranış Puanlama:** Kulüp sahibi tarafından futbolcunun davranışını puanlama.
- **Sözleşme Feshi:** Sözleşmeyi feshetme yetkisi.

## Akıllı Sözleşme İşlevleri

### Yapıcı Fonksiyon (Constructor)

```solidity
constructor(
    address _player,
    uint _startDate,
    uint _endDate,
    uint _salary,
    uint _bonus,
    uint _transferFee,
    uint _releaseFee,
    string memory _behaviorRules,
    string memory _sponsorshipRights
)

## sözleşme güncelleme
 
function updateContractDetails(
    uint _startDate,
    uint _endDate,
    uint _salary,
    uint _bonus,
    uint _transferFee,
    uint _releaseFee,
    string memory _behaviorRules,
    string memory _sponsorshipRights
) external onlyOwner

## Maaş ödemesi

function paySalary() external onlyOwner


### Transfer Ücreti Ödemesi

function payTransferFee() external onlyOwner

### Serbest Bırakma Ücreti Ödemesi

function payReleaseFee() external onlyPlayer



### Sigorta ve Sağlık Ücretleri

function setInsuranceFee(uint _insuranceFee) external onlyOwner 
function setHealthFee(uint _healthFee) external onlyOwner 
function payInsuranceFee() external onlyOwner 
function payHealthFee() external onlyOwner 


###Bonus Ödemesi

function payBonus() external onlyOwner


####Performans Güncelleme


function updatePerformance(address _player, uint _performanceScore) external onlyOwner 

####Sözleşme Süresini Uzatma

function extendContract(uint _newEndDate) external onlyOwner


###İade Fonksiyonu


function refundPayment(uint _amount) external onlyOwner


###Sözleşmeyi Feshetme

function terminateContract() public


####İhtarname Gönderme

function issueWarning(string memory _message) external onlyOwner


####Davranış Puanlama

function rateBehavior(uint _rating, string memory _comment) external onlyOwner


####Sözleşme Bilgilerini Görüntüleme


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
)


####Sözleşmenin Bakiyesini Görüntüleme

function getContractBalance() external view returns (uint) 
