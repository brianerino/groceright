import sys
sys.path.insert(0, '/etc/secrets')

from flask import Flask, request, jsonify, render_template
from sql_connection import get_sql_connection
import products_dao
import orders_dao
import uom_dao
import category_dao

app = Flask(__name__)


# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------
def calculate_order_total(connection, order_id):
    """
    Recalculates and updates the total_bill for a given order_id by summing
    all line-item totals in order_detail.
    """
    cursor = connection.cursor()
    # Fetch sum of total_price_per_item for this order
    cursor.execute("""
    	SELECT SUM(total_price_per_item)
        FROM order_detail
        WHERE order_id = %s
        """, (order_id,))
    total = cursor.fetchone()[0] or 0
    # Update order_sheet with the rounded total
    cursor.execute("""
            UPDATE order_sheet
            SET total_bill = %s
            WHERE order_id = %s
        """, (round(total, 2), order_id))
    connection.commit()
    cursor.close()


# -----------------------------------------------------------------------------
# HTML Page Routes
# -----------------------------------------------------------------------------
@app.route('/')
def login():
    """Render login page."""
    return render_template('login.html')

@app.route('/index')
def index():
    """Render main dashboard page."""
    return render_template('index.html')

@app.route('/orders')
def orders_page():
    """Render orders listing page."""
    return render_template('order.html')

@app.route('/newOrder')
def new_order():
    """Render new order creation page."""
    return render_template('new_order.html')

@app.route('/manage')
def manage():
    """Render product management page."""
    return render_template('manage_product.html')

@app.route('/notifications')
def notifications_page():
    """Render low-stock notifications page."""
    return render_template('notifications.html')

@app.route('/orders/<int:order_id>')
def order_details(order_id):
    """
    Render order details page for a specific order.
    Also recalculates total_bill to ensure accuracy before rendering.
    """
    connection = get_sql_connection()
    order_items = orders_dao.get_order_details(connection, order_id)
    calculate_order_total(connection, order_id)
    connection.close()
    return render_template('order_details.html', order_id=order_id, order_items=order_items)


# -----------------------------------------------------------------------------
# API Endpoints
# -----------------------------------------------------------------------------
@app.route('/getUOMs')
def get_uoms():
    """Return JSON list of units of measurement."""
    connection = get_sql_connection()
    try:
        return jsonify(uom_dao.get_uoms(connection))
    except Exception as e:
        app.logger.error("Error loading UOMs: %s", e)
        return "Error loading UOMs", 500
    finally:
        connection.close()


@app.route('/getProducts')
def get_products():
    """Return JSON list of all products."""
    connection = get_sql_connection()
    try:
        return jsonify(products_dao.get_all_products(connection))
    finally:
        connection.close()


@app.route('/addProduct', methods=['POST'])
def add_product():
    """Insert a new product and return status."""
    data = request.get_json()
    connection = get_sql_connection()
    try:
        product = {
            'name':           data['name'],
            'category_id':    data['category_id'],
            'subcategory_id': data['subcategory_id'],
            'uom_id':         data['uom_id'],
            'price':          data['price'],
            'quantity':       data['quantity']
        }
        products_dao.insert_product(connection, product)
        return jsonify({'status':'ok'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        connection.close()


@app.route('/updateProduct/<int:product_id>', methods=['POST'])
def update_product(product_id):
    """Update an existing product and return status."""
    data = request.get_json()
    connection = get_sql_connection()
    try:
        # Build a single dict for the DAO
        product = {
            'product_id':     product_id,
            'product_name':   data['name'],
            'category_id':    data['category_id'],
            'subcategory_id': data['subcategory_id'],
            'uom_id':         data['uom_id'],
            'price_per_unit': data['price'],
            'quantity':       data['quantity']
        }

        products_dao.update_product(connection, product)
        return jsonify({'status': 'ok'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        connection.close()


@app.route('/deleteProduct/<int:id>', methods=['DELETE'])
def delete_product(id):
    """Delete product by ID."""
    connection = get_sql_connection()
    try:
        products_dao.delete_product(connection, id)
        return '', 200
    finally:
        connection.close()


@app.route('/searchProducts')
def search_products():
    """Search products by name substring; return JSON list."""
    name = request.args.get('name', '')
    connection = get_sql_connection()
    try:
        return jsonify(products_dao.search_products_by_name(connection, name))
    finally:
        connection.close()


@app.route('/getCategories')
def get_categories():
    """Return JSON list of all categories."""
    return jsonify(category_dao.get_all_categories())


@app.route('/getSubcategories')
def get_subcategories():
    """Return JSON list of subcategories for given category_id."""
    category_id = request.args.get('category_id')
    return jsonify(category_dao.get_subcategories_by_category(category_id))


@app.route('/getAllSubcategories')
def get_all_subcategories():
    """Return JSON list of all subcategories."""
    return jsonify(category_dao.get_all_subcategories())


@app.route('/filterProductsAdvanced')
def filter_products_advanced_route():
    """
    Advanced filtering endpoint: accepts comma-separated lists and
    numeric ranges, returns JSON list of matching products.
    """
    # Parse query parameters into appropriate types
    categories    = request.args.get('categories')
    subcategories = request.args.get('subcategories')
    units         = request.args.get('units')
    min_price     = request.args.get('min_price')
    max_price     = request.args.get('max_price')
    min_quantity  = request.args.get('min_quantity')
    max_quantity  = request.args.get('max_quantity')

    category_list    = categories.split(',')    if categories    else []
    subcategory_list = subcategories.split(',') if subcategories else []
    unit_list        = units.split(',')         if units         else []
    min_price        = float(min_price)         if min_price     else None
    max_price        = float(max_price)         if max_price     else None
    min_quantity     = int(min_quantity)        if min_quantity  else None
    max_quantity     = int(max_quantity)        if max_quantity  else None

    filtered = products_dao.filter_products_advanced(
        connection   = get_sql_connection(),
        categories   = category_list,
        subcategories= subcategory_list,
        units        = unit_list,
        min_price    = min_price,
        max_price    = max_price,
        min_quantity = min_quantity,
        max_quantity = max_quantity
    )
    return jsonify(filtered)

@app.route('/filterProducts')
def filter_products():
    """Simple filter by category/subcategory/price; return JSON list."""
    args = request.args
    filters = {
        'category_id': args.get('category_id'),
        'subcategory_id': args.get('subcategory_id'),
        'min_price': args.get('min_price'),
        'max_price': args.get('max_price')
    }

    connection = get_sql_connection()
    try:
        return jsonify(products_dao.filter_products(connection, filters))
    finally:
        connection.close()

@app.route('/submitOrder', methods=['POST'])
def submit_order():
    """
    Validate and submit a new order:
      - Ensures products exist & stock is sufficient
      - Computes grand total, inserts into order_sheet & order_detail
      - Deducts stock quantities
    """
    data = request.get_json()
    customer_name = data.get('customer_name', '').strip() or 'Guest'
    connection = get_sql_connection()
    try:
        # Build lookup for validation
        all_products = {
            p['product_name']: p
            for p in products_dao.get_all_products(connection)
        }
        order_items, grand_total = [], 0

        # Validate each line item and accumulate totals
        for item in data['items']:
            product = all_products.get(item['name'])
            if not product:
                return jsonify({'error': f"Product '{item['name']}' not found"}), 400
            if product['quantity'] < item['quantity']:
                return jsonify({
                    'error': (
                        f"Not enough stock for '{item['name']}'. "
                        f"Available: {product['quantity']}, "
                        f"Requested: {item['quantity']}"
                    )
                }), 400

            line_total = item['unit_price'] * item['quantity']
            order_items.append({
                'product_id': product['product_id'],
                'quantity':    item['quantity'],
                'total_price': line_total
            })
            grand_total += line_total

        # Insert master & detail rows
        order_id = orders_dao.insert_order(connection, {
            'customer_name':  customer_name,
            'grand_total':    grand_total,
            'order_details':  order_items
        })

        # Deduct stock levels
        cursor = connection.cursor()
        for li in order_items:
            cursor.execute(
                '''
                UPDATE product
                   SET quantity = quantity - %s
                 WHERE product_id = %s
                ''',
                (li['quantity'], li['product_id'])
            )
        connection.commit()
        cursor.close()

        return jsonify({'order_id': order_id}), 200
    finally:
        connection.close()


@app.route('/getOrders')
def get_orders():
    """
    Return simplified JSON list of all orders with:
        order_id, customer_name, total, formatted date_time.
    """
    connection = get_sql_connection()
    orders = orders_dao.get_all_orders(connection)
    connection.close()
    # Reformat for frontend
    result = [{
        'order_id':      o['order_id'],
        'customer_name': o['customer_name'],
        'total':         o['total'],
        'date_time':     o['datetime'].strftime('%Y-%m-%d %H:%M:%S') if o['datetime'] else ''
    } for o in orders]
    return jsonify(result)

@app.route('/api/notifications')
def get_notifications():
    """
    Return low-stock product notifications (quantity < 100).
    JSON format: [{product_id, product_name, quantity}, ...]
    """
    connection = get_sql_connection()
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("""
            SELECT product_id, product_name, quantity
              FROM product
             WHERE quantity < 100
             ORDER BY quantity ASC
        """)
        return jsonify(cursor.fetchall())
    finally:
        connection.close()

# -----------------------------------------------------------------------------
# Application Entrypoint
# -----------------------------------------------------------------------------
if __name__ == "__main__":
	app.run(port=5000, debug=True)