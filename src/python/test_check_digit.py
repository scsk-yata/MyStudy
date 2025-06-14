import unittest # 単体テスト機能モジュール
from check_digit import check_digit

class TestCheckDigit(unittest.TestCase):
    def test_check_digit(self):
        self.assertEqual(7, check_digit('9784798157207'))
        self.assertEqual(6, check_digit('9784798160016'))
        self.assertEqual(0, check_digit('9784798141770'))
        
if __name__ == "__main__":
    unittest.main()