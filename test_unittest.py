import unittest
from task_list import Task


class Test_AddCompleteTask(unittest.TestCase):
    def test_add(self):
        self.assertEqual(inc_dec.increment(3), 4)

    def test_decrement(self):
        self.assertEqual(inc_dec.decrement(3), 4)

if __name__ == '__main__':
    unittest.main()