pragma solidity ^0.4.0;
    /* This contract was created by Mario Granero Burillo
    for the I HackETHon in THECUBEMADRID
    for the dAPP project TraceabilityOfFairTrade */
contract TraceabilityOfFairTrade {

//This address are mocked, after that, we will try to make mappings

    address owner;
    address rawMaterials;
    address productor;
    address transporter;
    address distributor;
    address consumer;
    address validator;

    uint256 idProductIndex;

//The product cicle is described with this states
    enum ProductStatus {notStarted,
                        rawMaterialExtracted,
                        rawMaterialExtractedValidation,
                        produced,
                        productionValidated,
                        transported,
                        transportValidated,
                        distributed,
                        distributionValidated,
                        consumed,
                        recicled}
// Product structure
    struct Product {
        string productName;
        ProductStatus productStatus;
    }
// Products collection of the contract
    mapping(uint256 => Product) products;

// MODIFIERS
// This modifier inspect if sender is a validator of a process. In the future, each rol, will have their own validator
    modifier onlyValidator() {
        require(msg.sender == validator);
        _;
    }
// This modifier will allow only the participants address to avoid public interactions
    modifier onlyParticipant() {
        require((msg.sender == rawMaterials)||
                (msg.sender == productor)||
                (msg.sender == transporter)||
                (msg.sender == distributor)||
                (msg.sender == consumer));
        _;
    }
// This main function will change state making validations with only validator role
    function ProcessValidation(uint256 idProduct)  onlyValidator() {
        uint256 previousStatus = uint256(products[idProduct].productStatus);
        products[idProduct].productStatus = ProductStatus(previousStatus+1);
    }
// This main function will change state making validations with only validator role
// This main function will change to the next step with conditions and validations
    function processDone (uint256 idProduct) onlyParticipant() {
        if ((msg.sender == rawMaterials)&&(products[idProduct].productStatus == ProductStatus(0))) {
            products[idProduct].productStatus = ProductStatus.rawMaterialExtracted;
        }
        if ((msg.sender == productor)&&(products[idProduct].productStatus == ProductStatus(2))) {
            products[idProduct].productStatus = ProductStatus.produced;
        }
        if ((msg.sender == transporter)&&(products[idProduct].productStatus == ProductStatus(4))) {
            products[idProduct].productStatus = ProductStatus.transported;
        }
        if ((msg.sender == distributor)&&(products[idProduct].productStatus == ProductStatus(6))) {
            products[idProduct].productStatus = ProductStatus.distributed;
        }
        if ((msg.sender == consumer)&&(products[idProduct].productStatus == ProductStatus(8))) {
            products[idProduct].productStatus = ProductStatus.consumed;
        }
        if ((msg.sender == consumer)&&(products[idProduct].productStatus == ProductStatus(9))) {
            products[idProduct].productStatus = ProductStatus.recicled;
        }
    }
// MAIN CONSTRUCTOR
    function TraceabilityOfFairTrade ()  {
        owner = 0x467c8702ac386528994E2C85ceCE318b0D6e632C;
        validator = 0x467c8702ac386528994E2C85ceCE318b0D6e632C;
        rawMaterials = 0x467c8702ac386528994E2C85ceCE318b0D6e632C;
        productor = 0x467c8702ac386528994E2C85ceCE318b0D6e632C;
        transporter = 0x467c8702ac386528994E2C85ceCE318b0D6e632C;
        distributor = 0x467c8702ac386528994E2C85ceCE318b0D6e632C;
        consumer = 0x467c8702ac386528994E2C85ceCE318b0D6e632C;
        idProductIndex = 0;
    }
// function to create a product
    function newProduct (string _productName)  returns (uint256 _idProduct) {
        _idProduct = idProductIndex + 1;
        products[_idProduct].productName = _productName;
        products[_idProduct].productStatus = ProductStatus(0);
        return (_idProduct);
    }
// GETTERS
    function getProductStatus (uint256 _idProduct)  returns (uint256 _productStatus) {
        _productStatus = uint256(products[_idProduct].productStatus);
        return (_productStatus);
    }
    function getProductName (uint256 _idProduct)  returns (string _productName) {
        _productName = products[_idProduct].productName;
        return (_productName);
    }
    function getProduct (uint256 _idProduct)  returns (string _productName, uint256 _productStatus) {
        _productName = products[_idProduct].productName;
        _productStatus = uint256(products[_idProduct].productStatus);
        return (_productName,_productStatus);
    }
    function getNumberOfProducts () returns (uint256 _numberOfProducts) {
        _numberOfProducts = idProductIndex;
        return _numberOfProducts;
    }
    function getNumberOfProductsByState (uint256 _productState) returns (uint _numberOfProducts) {
        uint256 count = 0;
        for (uint256 i=0;i<idProductIndex;i++){
            if (products[i].productStatus == ProductStatus(_productState)) {
                count +=1;
            }
        }
        _numberOfProducts = count;
        return _numberOfProducts;
    }
}
