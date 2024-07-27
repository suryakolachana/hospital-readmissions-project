import unittest
from unittest.mock import patch, MagicMock
from google.cloud import bigquery
import main  # Import the Ingest Cloud Function script

class TestCloudFunction(unittest.TestCase):
    @patch('main.bigquery.Client')
    def test_ingest(self, mock_bigquery_client):
        # Mock the event and context
        event = {
            'bucket': 'data-sci-prod-raw-zone',
            'name': 'test_file.csv'
        }
        context = MagicMock()

        # Mock the BigQuery client and load_table_from_uri method
        mock_bq_client_instance = mock_bigquery_client.return_value
        mock_bq_client_instance.project = 'named-vine-254515' # Please Update with your own project ID. 
        mock_load_table_from_uri = MagicMock()
        mock_bq_client_instance.load_table_from_uri = mock_load_table_from_uri
        
        # Add logging to verify mock setup
        print(f"Mock project: {mock_bq_client_instance.project}")
        print(f"Mock load_table_from_uri: {mock_load_table_from_uri}")
        
        # Call the ingest function
        main.ingest(event, context)

        # Assertions
        self.assertTrue(mock_load_table_from_uri.called, "load_table_from_uri was not called")


if __name__ == '__main__':
    unittest.main()
