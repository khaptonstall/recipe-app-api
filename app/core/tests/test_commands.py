from unittest.mock import patch

from django.core.management import call_command
from django.db.utils import OperationalError
from django.test import TestCase


class CommandTests(TestCase):

    def test_wait_for_db_ready(self):
        """Test waiting for db when db is available"""
        with patch('django.db.utils.ConnectionHandler.__getitem__') as gi:
            gi.return_value = True
            call_command('wait_for_db')
            self.assertEqual(gi.call_count, 1)

    # Add a patch decorator to override time.sleep to automatically return
    @patch('time.sleep', return_value=None)
    def test_wait_for_db(self, ts):
        """Test waiting for db"""
        with patch('django.db.utils.ConnectionHandler.__getitem__') as gi:
            # The first 5 times we call __getitem__ throw an OperationalError
            gi.side_effect = [OperationalError] * 5 + [True]

            # On the 6th call, it should succeed
            call_command('wait_for_db')
            self.assertEqual(gi.call_count, 6)
