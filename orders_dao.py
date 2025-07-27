import sys
sys.path.insert(0, '/etc/secrets')

from datetime import datetime
from sql_connection import get_sql_connection

# ======================================================================
# ORDER DATA ACCESS OBJECT (DAO)
# ======================================================================

def insert_order(connection, order):
    """
    Create a new order: inserts master record and its line items.
    Args:
        connection: Active DB connection (transaction managed by caller).
        order (dict): {
            'customer_name': str,
            'grand_total': float,
            'order_details': [
                {'product_id': int, 'quantity': int, 'total_price': float}, ...
            ]
        }
    Returns:
        int: Newly created order_id.
    """
    cursor = connection.cursor()
    try:
        # --------------------
        # 1) Insert master record into order_sheet
        # --------------------
        order_sql = """
            INSERT INTO order_sheet (customer_name, total_bill, date_time)
            VALUES (%s, %s, %s)
        """
        order_data = (
            order['customer_name'],
            order['grand_total'],
            datetime.now()         # use server-side timestamp
        )
        cursor.execute(order_sql, order_data)
        order_id = cursor.lastrowid  # retrieve generated PK

        # --------------------
        # 2) Batch-insert order_detail rows
        # --------------------
        detail_sql = """
            INSERT INTO order_detail
                (order_id, product_id, item_quantity, total_price_per_item)
            VALUES (%s, %s, %s, %s)
        """
        # Prepare parameter list for executemany
        detail_params = [
            (
                order_id,
                int(item['product_id']),
                int(item['quantity']),
                float(item['total_price'])
            )
            for item in order['order_details']
        ]
        cursor.executemany(detail_sql, detail_params)

        # Commit master + detail inserts as a single transaction
        connection.commit()
        return order_id

    except Exception:
        connection.rollback()  # rollback on error
        raise

    finally:
        cursor.close()


def get_order_details(connection, order_id):
    """
    Retrieve line items for a given order.
    Args:
        connection: Active DB connection.
        order_id (int): Identifier of the master order record.
    Returns:
        List[Dict]: Each dict contains:
            order_id, product_id, product_name,
            quantity, unit_price, total_price
    """
    cursor = connection.cursor()
    try:
        sql = """
            SELECT
                od.order_id,
                od.product_id,
                p.product_name,
                od.item_quantity    AS quantity,
                p.price_per_unit    AS unit_price,
                od.total_price_per_item AS total_price
            FROM order_detail od
            JOIN product p
              ON p.product_id = od.product_id
            WHERE od.order_id = %s
        """
        cursor.execute(sql, (order_id,))

        results = []
        for (oid, pid, pname, qty, unitprice, totalprice) in cursor:
            results.append({
                'order_id':     oid,
                'product_id':   pid,
                'product_name': pname,
                'quantity':     qty,
                'unit_price':   float(unitprice),
                'total_price':  float(totalprice)
            })
        return results

    finally:
        cursor.close()


def get_all_orders(connection):
    """
    Fetch all orders in ascending order_id.
    Args:
        connection: Active DB connection.
    Returns:
        List[Dict]: Each dict contains:
            order_id, customer_name, total (float), datetime (datetime)
    """
    cursor = connection.cursor()
    try:
        sql = """
          SELECT
             order_id,
             customer_name,
             total_bill AS total,
             date_time  AS datetime
          FROM order_sheet
          ORDER BY order_id ASC
        """
        cursor.execute(sql)

        orders = []
        for (oid, cname, total, dt) in cursor:
            orders.append({
                'order_id':      oid,
                'customer_name': cname,
                'total':         float(total),
                'datetime':      dt
            })
        return orders

    finally:
        cursor.close()


# ----------------------------------------------------------------------
# Example entrypoint for manual testing (not used in production routes)
# ----------------------------------------------------------------------
if __name__ == '__main__':
    conn = get_sql_connection()
    try:
        print("Existing orders:", get_all_orders(conn))
    finally:
        conn.close()