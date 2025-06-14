class User:
    def __init__(self, name, password):
        self.name = name
        self.__password = password
        
u = User('admin', 'password')
print(u.name)
print(u.__password)