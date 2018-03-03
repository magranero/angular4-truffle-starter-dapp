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

    enum ProductStatus {rawMaterials,rawMaterialsValidated, producted, productionValidated, transported, transportValidated, distributed, distributionValidated, consumed, consumptionValidated}

    struct Product {
        string productName;
        ProductStatus productStatus;
    }

    mapping(uint256 => Product) products;

    modifier onlyValidator() {
        require(msg.sender == validator);
        _;
    }
    modifier onlyRawMaterials(uint256 idProduct)  {
        require(msg.sender == rawMaterials);
        require(products[idProduct].productStatus == ProductStatus(0));
        _;
    }

    modifier onlyProductor(uint256 idProduct) {
        require(msg.sender == productor);
        require(products[idProduct].productStatus == ProductStatus(2));
        _;
    }

    modifier onlyTransporter(uint256 idProduct) {
        require(msg.sender == transporter);
        require(products[idProduct].productStatus == ProductStatus(4));
        _;
    }
    modifier onlyDistributor(uint256 idProduct) {
        require(msg.sender == distributor);
        require(products[idProduct].productStatus == ProductStatus(6));
        _;
    }

    modifier onlyConsumer(uint256 idProduct) {
        require(msg.sender == consumer);
        require(products[idProduct].productStatus == ProductStatus(8));
        _;
    }

    function validateProcess(uint256 idProduct)  onlyValidator() {
        uint256 previousStatus = uint256(products[idProduct].productStatus);
        products[idProduct].productStatus = ProductStatus(previousStatus+1);
    }

    function rawMaterialDone(uint256 idProduct)  onlyRawMaterials(idProduct) {
        products[idProduct].productStatus = ProductStatus.rawMaterials;
    }
    function production(uint256 idProduct)  onlyProductor(idProduct) {
        products[idProduct].productStatus = ProductStatus.producted;

    }
    function transportDone(uint256 idProduct)  onlyTransporter(idProduct) {
        products[idProduct].productStatus = ProductStatus.transported;

    }
    function distributionDone(uint256 idProduct)  onlyDistributor(idProduct) {
        products[idProduct].productStatus = ProductStatus.distributed;

    }
    function consumptionDone(uint256 idProduct)  onlyConsumer(idProduct) {
        products[idProduct].productStatus = ProductStatus.consumptionValidated;

    }
    function recicleDone(uint256 idProduct)  onlyConsumer(idProduct) {
        products[idProduct].productStatus = ProductStatus.consumptionValidated;

    }

    function TraceabilityOfFairTrade(address _validator, address _rawMaterials, address _productor, address _transporter, address _distributor, address _consumer)  {
        owner = msg.sender;
        validator = _validator;
        rawMaterials = _rawMaterials;
        productor = _productor;
        transporter = _transporter;
        distributor = _distributor;
        consumer = _consumer;
        idProductIndex = 0;
    }
    function newProduct(string _productName)  returns (uint256 _idProduct) {
        _idProduct = idProductIndex + 1;
        products[_idProduct].productName = _productName;
        products[_idProduct].productStatus = ProductStatus(0);
        return (_idProduct);
    }

}
