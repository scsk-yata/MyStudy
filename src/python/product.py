class Product:
    def __init__(self,name,price):
        self.__name = name
        self.__price = price
        print('constructor')
        
    def __del__(self):
        print('destructor')
        
    def get_price(self,count):
        return self.__price * count

product = Product('book',100) # インスタンスの生成
print(product.get_price(3))