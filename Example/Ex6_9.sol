contract Ex6_9{

    event Information(string info);
    enum FoodProcess{
        order,
        takeAway,
        delivery,
        payment
    }
    FoodProcess public foodStatus;

    constructor(){
        foodStatus=FoodProcess.payment;
    }
    function orderFood() public{
        require(foodStatus==FoodProcess.payment,"It must be the payment status");
        foodStatus=FoodProcess.order;
        emit Information("Order success");
    }
    function takeAwayFood() public{
        require(foodStatus==FoodProcess.order,"It must be the order status");
        foodStatus=FoodProcess.takeAway;
        emit Information("takeAway success");
    }
    function deliveryFoood() public{
        require(foodStatus==FoodProcess.takeAway,"It must be the takeAway status");
        foodStatus=FoodProcess.delivery;
        emit Information("delivery success");
    }
    function paymentFood() public{
        require(foodStatus==FoodProcess(2),"It must be the delivery status");
        foodStatus=FoodProcess.payment;
        emit Information("payment success");
    }
}