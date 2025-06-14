class Book:
    def __init__(self, title, price):
        self.title = title
        self.price = price
        self.print = 1
        
def reprint(self):
    self.print += 1
    return '%s : %i 刷' %(self.title, self.print)

security = Book('セキュリティの仕組み',1680)
programming = Book('プログラミングの仕組み',1780)
reprint(security)
print(security.print)
reprint(security)
print('%s : %i 刷' %(security.title, security.print))
reprint(security)
print('%s : %i 円 : %i 刷' %(security.title, security.price, security.print))