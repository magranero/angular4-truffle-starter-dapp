pragma solidity ^0.4.0;
contract TraceabilityOfFairTrade {

    address owner;
    address rawMaterials;
    address productor;
    address transporter;
    address distributor;
    address consumer;
    address validator;
    
    uint256 idProductIndex;

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
    struct Product {
        string productName;
        ProductStatus productStatus;
    }
    mapping(uint256 => Product) products;
    
    modifier onlyValidator() {
        require(msg.sender == validator);
        _;
    }
    modifier onlyParticipant() {
        require((msg.sender == rawMaterials)||
                (msg.sender == productor)||
                (msg.sender == transporter)||
                (msg.sender == distributor)||
                (msg.sender == consumer));
        _;
    }
    function ProcessValidation(uint256 idProduct)  onlyValidator() {
        uint256 previousStatus = uint256(products[idProduct].productStatus);
        products[idProduct].productStatus = ProductStatus(previousStatus+1);
    }
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
    function TraceabilityOfFairTrade (address _validator, address _rawMaterials, address _productor, address _transporter, address _distributor, address _consumer)  {
        owner = msg.sender;
        validator = _validator;
        rawMaterials = _rawMaterials;
        productor = _productor;
        transporter = _transporter;
        distributor = _distributor;
        consumer = _consumer;
        idProductIndex = 0;
    }
    function newProduct (string _productName)  returns (uint256 _idProduct) {
        _idProduct = idProductIndex + 1;
        products[_idProduct].productName = _productName;
        products[_idProduct].productStatus = ProductStatus(0);
        return (_idProduct);
    }
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
    function getNumberOfProducts (uint256 _idProduct) returns (uint _numberOfProducts) {
        _numberOfProducts = idProductIndex;
        return _numberOfProducts;
    }
    function getNumberOfProductsByState (uint256 _idProduct) returns (uint _numberOfProducts) {
        uint256 count;
        return _numberOfProducts;
    }

}
