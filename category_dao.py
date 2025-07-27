import sys
sys.path.insert(0, '/etc/secrets')

from sql_connection import get_sql_connection

# -------------------------------------------------------------------------------
# CATEGORY DATA ACCESS OBJECT (DAO)
# -------------------------------------------------------------------------------

def get_all_categories():
    """
    Retrieve all product categories.
    Returns:
        List[Dict]: Each dict contains 'category_id' and 'category_name'.
    """
    # Acquire a new DB connection
    conn = get_sql_connection()
    try:
        # Use dictionary cursor for more readable column access
        cursor = conn.cursor(dictionary=True)

        # Execute query to fetch all categories
        cursor.execute("""
            SELECT category_id, category_name
            FROM category
        """)

        # Fetch and return list of dict rows
        return cursor.fetchall()

    finally:
        # Ensure resources are always cleaned up
        cursor.close()
        conn.close()


def get_all_subcategories():
    """
    Retrieve all subcategories across all categories.
    Returns:
        List[Dict]: Each dict contains 'subcategory_id', 'subcategory_name', 'category_id'.
    """
    conn = get_sql_connection()
    try:
        cursor = conn.cursor()
        # Query includes foreign key for category association
        cursor.execute("""
            SELECT subcategory_id, subcategory_name, category_id
            FROM subcategory
        """)
        rows = cursor.fetchall()

        # Transform tuple rows into list of dicts for consistency
        return [
            {
                'subcategory_id': row[0],
                'subcategory_name': row[1],
                'category_id': row[2]
            }
            for row in rows
        ]

    finally:
        cursor.close()
        conn.close()


def get_subcategories_by_category(category_id):
    """
    Retrieve subcategories for a specific category.
    Args:
        category_id (int): Parent category identifier.
    Returns:
        List[Dict]: Each dict contains 'subcategory_id' and 'subcategory_name'.
    """
    conn = get_sql_connection()
    try:
        # Dictionary cursor for named access
        cursor = conn.cursor(dictionary=True)

        # Parameterized query to avoid SQL injection
        cursor.execute("""
            SELECT subcategory_id, subcategory_name
              FROM subcategory
             WHERE category_id = %s
        """, (category_id,))

        return cursor.fetchall()

    finally:
        cursor.close()
        conn.close()