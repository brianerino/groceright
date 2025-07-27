import sys
sys.path.insert(0, '/etc/secrets')

from sql_connection import get_sql_connection

# ======================================================================
# PRODUCT DATA ACCESS OBJECT (DAO)
# ======================================================================

def insert_product(connection, product):
    """
    Insert a new product record into the database.
    Args:
        connection: Active DB connection (transaction managed by caller).
        product (dict): {
            'name': str,
            'category_id': int,
            'subcategory_id': int,
            'uom_id': int,
            'price': float,
            'quantity': int
        }
    Returns:
        None
    """
    cursor = connection.cursor()
    try:
        # ------------------------------------------------------------------
        # Prepare INSERT statement with all required fields
        # ------------------------------------------------------------------
        query = """
			INSERT INTO product
				(product_name, category_id, subcategory_id, uom_id, price_per_unit, quantity)
			VALUES (%s, %s, %s, %s, %s, %s)
        """
        data = (
			product['name'],
			product['category_id'],
			product['subcategory_id'],
			product['uom_id'],
			product['price'],
			product['quantity']
        )
        cursor.execute(query, data)
        connection.commit()  # Persist changes
    finally:
        cursor.close()


def update_product(connection, product):
    """
    Update an existing product record.
    Args:
        connection: Active DB connection.
        product (dict): {
            'product_id': int,
            'product_name': str,
            'category_id': int,
            'subcategory_id': int,
            'uom_id': int,
            'price_per_unit': float,
            'quantity': int
        }
    Returns:
        None
    """
    cursor = connection.cursor()
    try:
        # ------------------------------------------------------------------
        # Prepare UPDATE statement targeting the given product_id
        # ------------------------------------------------------------------
        query = """
			UPDATE product
			SET
				product_name     = %s,
				category_id      = %s,
				subcategory_id   = %s,
				uom_id           = %s,
				price_per_unit   = %s,
				quantity         = %s
			WHERE product_id = %s
        """
        params = (
			product['product_name'],
			product['category_id'],
			product['subcategory_id'],
			product['uom_id'],
			product['price_per_unit'],
			product['quantity'],
			product['product_id']
        )
        cursor.execute(query, params)
        connection.commit()  # Persist changes
    finally:
        cursor.close()


def delete_product(connection, product_id):
    """
    Delete a product record by its ID.
    Args:
        connection: Active DB connection.
        product_id (int): Identifier of the product to delete.
    Returns:
        None
    """
    cursor = connection.cursor()
    try:
        query = "DELETE FROM product WHERE product_id = %s"
        cursor.execute(query, (product_id,))
        connection.commit()  # Persist deletion
    finally:
        cursor.close()


def get_all_products(connection):
    """
    Retrieve all products along with their category, subcategory, and UOM names.
    Args:
        connection: Active DB connection.
    Returns:
        List[dict]: Each dict contains:
            product_id, product_name,
            category_id, category_name,
            subcategory_id, subcategory_name,
            uom_id, uom_name,
            price_per_unit, quantity
    """
    cursor = connection.cursor(dictionary=True)
    try:
        cursor.execute("""
			SELECT 
				p.product_id,
				p.product_name,
				p.category_id,    c.category_name,
				p.subcategory_id, s.subcategory_name,
				p.uom_id,         u.uom_name,
				p.price_per_unit,
				p.quantity
			FROM product p
			LEFT JOIN category c ON p.category_id    = c.category_id
			LEFT JOIN subcategory s ON p.subcategory_id = s.subcategory_id
			LEFT JOIN unit_of_measurement u ON p.uom_id = u.uom_id
        """)
        return cursor.fetchall()
    finally:
        cursor.close()


def search_products_by_name(connection, name):
    """
    Search products whose names contain the given substring.
    Args:
        connection: Active DB connection.
        name (str): Substring to match against product_name.
    Returns:
        List[dict]: Same structure as get_all_products.
    """
    cursor = connection.cursor(dictionary=True)
    try:
        query = """
			SELECT 
				p.product_id,
				p.product_name,
				p.category_id,    c.category_name,
				p.subcategory_id, s.subcategory_name,
				p.uom_id,         u.uom_name,
				p.price_per_unit,
				p.quantity
			FROM product p
			LEFT JOIN category c        ON p.category_id    = c.category_id
			LEFT JOIN subcategory s     ON p.subcategory_id = s.subcategory_id
			LEFT JOIN unit_of_measurement u ON p.uom_id       = u.uom_id
			WHERE p.product_name LIKE %s
        """
        like_pattern = f"%{name}%"
        cursor.execute(query, (like_pattern,))
        return cursor.fetchall()
    finally:
        cursor.close()


def filter_products(connection, filters):
    """
    Filter products by optional category_id, subcategory_id, price range.
    Args:
        connection: Active DB connection.
        filters (dict): May include keys:
            'category_id', 'subcategory_id', 'min_price', 'max_price'
    Returns:
        List[dict]: Same structure as get_all_products.
    """
    cursor = connection.cursor(dictionary=True)
    try:
        query = """
			SELECT 
				p.product_id, p.product_name,
				c.category_name, s.subcategory_name,
				u.uom_name, p.price_per_unit, p.quantity
			FROM product p
			LEFT JOIN category c ON p.category_id    = c.category_id
			LEFT JOIN subcategory s ON p.subcategory_id = s.subcategory_id
			LEFT JOIN unit_of_measurement u ON p.uom_id = u.uom_id
         	WHERE 1 = 1
        """
        params = []

        # Dynamically append filters
        if filters.get('category_id'):
            query += " AND p.category_id = %s"
            params.append(filters['category_id'])
        if filters.get('subcategory_id'):
            query += " AND p.subcategory_id = %s"
            params.append(filters['subcategory_id'])
        if filters.get('min_price'):
            query += " AND p.price_per_unit >= %s"
            params.append(filters['min_price'])
        if filters.get('max_price'):
            query += " AND p.price_per_unit <= %s"
            params.append(filters['max_price'])

        cursor.execute(query, tuple(params))
        return cursor.fetchall()
    finally:
        cursor.close()


def filter_products_advanced(connection, categories, subcategories,
  units, min_price=None, max_price=None, min_quantity=None, max_quantity=None):
    """
    Advanced filtering: supports lists for category, subcategory, units,
    as well as numeric ranges for price and quantity.
    Args:
        connection: Active DB connection.
        categories (List[int]), subcategories (List[int]), units (List[int])
        min_price, max_price: optional floats
        min_quantity, max_quantity: optional ints
    Returns:
        List[dict]: Same structure as get_all_products.
    """
    cursor = connection.cursor(dictionary=True)
    try:
        # ------------------------------------------------------------------
        # Base SELECT with LEFT JOINs to fetch display names
        # ------------------------------------------------------------------
        query = """
            SELECT 
                p.product_id,
                p.product_name,
                c.category_name,
                s.subcategory_name,
                u.uom_name,
                p.price_per_unit,
                p.quantity
            FROM product p
            LEFT JOIN category c ON p.category_id    = c.category_id
            LEFT JOIN subcategory s ON p.subcategory_id = s.subcategory_id
            LEFT JOIN unit_of_measurement u ON p.uom_id = u.uom_id
            WHERE 1=1
        """
        params = []

        def in_clause(field, values):
            """Helper to generate SQL 'IN' clause and collect parameters."""
            placeholders = ','.join(['%s'] * len(values))
            return f" AND {field} IN ({placeholders})", values

        # Append IN clauses for list filters
        if categories:
            clause, vals = in_clause('p.category_id', categories)
            query  += clause; params += vals
        if subcategories:
            clause, vals = in_clause('p.subcategory_id', subcategories)
            query  += clause; params += vals
        if units:
            clause, vals = in_clause('p.uom_id', units)
            query  += clause; params += vals

        # Append range filters
        if min_price is not None:
            query  += " AND p.price_per_unit >= %s"; params.append(min_price)
        if max_price is not None:
            query  += " AND p.price_per_unit <= %s"; params.append(max_price)
        if min_quantity is not None:
            query  += " AND p.quantity >= %s"; params.append(min_quantity)
        if max_quantity is not None:
            query  += " AND p.quantity <= %s"; params.append(max_quantity)

        cursor.execute(query, tuple(params))
        return cursor.fetchall()
    finally:
        cursor.close()


# ----------------------------------------------------------------------
# Manual test entrypoint
# ----------------------------------------------------------------------
if __name__ == '__main__':
    connection = get_sql_connection()
    try:
        print(get_all_products(connection))
    finally:
        connection.close()
