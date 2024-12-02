import unittest
from typing import List

from airflow.models import DagBag
from airflow.operators.python import PythonOperator


class TestDAG(unittest.TestCase):
    """Test case for verifying the correctness of the 'monthly_extraction_financial_data' DAG.

    This test case ensures that the DAG is loaded properly, contains the expected tasks,
    and that the correct operators are used for each task.

    Attributes:
        dag (DAG): The DAG object to be tested.
    """

    @classmethod
    def setUpClass(cls) -> None:
        """Load the DAG for testing.

        Loads the 'monthly_extraction_financial_data' DAG from the specified folder and assigns it to
        the class variable `cls.dag`.
        """
        dagbag = DagBag(dag_folder="dags/investing_dag.py")
        cls.dag = dagbag.get_dag(dag_id="monthly_extraction_financial_data")

    def test_dag_loaded(self) -> None:
        """Test if the DAG is loaded successfully.

        Verifies that the DAG is not None and has the correct DAG ID.
        """
        self.assertIsNotNone(self.dag)
        self.assertEqual(self.dag.dag_id, "monthly_extraction_financial_data")

    def test_task_count(self) -> None:
        """Test the number of tasks in the DAG.

        Verifies that the DAG contains exactly 7 tasks.
        """
        self.assertEqual(len(self.dag.tasks), 7)

    def test_task_names(self) -> None:
        """Test the names of the tasks in the DAG.

        Verifies that the expected task names are present in the DAG.
        """
        task_ids: List[str] = [task.task_id for task in self.dag.tasks]
        self.assertIn("extract_chinese_caixin_services_index", task_ids)
        self.assertIn("extract_bloomberg_commodity_index", task_ids)
        self.assertIn("extract_usd_to_cny", task_ids)

if __name__ == "__main__":
    unittest.main()
