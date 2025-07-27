def get_uoms(connection):
    """
    Fetches all units of measurement from the database.

    Args:
        connection (mysql.connector.connection.MySQLConnection):
            An open MySQL connection.

    Returns:
        List[Dict[str, Any]]: A list of dicts, each containing:
            - 'uom_id' (int): The unit‐of‐measurement ID.
            - 'uom_name' (str): The human‐readable name of the unit.

    Raises:
        mysql.connector.Error: If the query execution fails.
    """
    # Use a standard cursor for simple SELECT
    cursor = connection.cursor()

    # Define the SQL to retrieve all UOM rows
    query = "SELECT uom_id, uom_name FROM unit_of_measurement"
    cursor.execute(query)

    # Build a list of dicts for the API response
    response = []
    for (uom_id, uom_name) in cursor:
        response.append({
            'uom_id':   uom_id,
            'uom_name': uom_name
        })

    # Clean up DB resources
    cursor.close()
    return response


if __name__ == '__main__':
    # Self‐test / standalone execution to verify DB connectivity and query
    import sys
    sys.path.insert(0, '/etc/secrets')
    from sql_connection import get_sql_connection

    connection = get_sql_connection()
    try:
        uoms = get_uoms(connection)
        print("Units of Measurement:", uoms)
    except Exception as e:
        # In a real system, use structured logging instead of print
        print("Error fetching UOMs:", e)
    finally:
        connection.close()
