$(document).ready(function () {
	// ---------------------------------------------------------------------------
	// INITIAL PAGE LOAD
	// ---------------------------------------------------------------------------
	// Populate dropdowns and table on initial load
	loadCategories();    // 1) Fetch & render categories dropdown
	loadProducts();      // 2) Fetch & render products table
	loadUOMs();          // 3) Fetch & render units‐of‐measure dropdown

	// ---------------------------------------------------------------------------
	// SAVE / UPDATE PRODUCT
	// ---------------------------------------------------------------------------
	$('#saveProduct').click(function () {
		const $btn = $(this);

		// Gather & validate form inputs
		const name = $('#name').val().trim();
		const price = parseFloat($('#price').val());
		const quantity = parseInt($('#quantity').val(), 10);
		const categoryId = $('#category').val();
		const subcategoryId = $('#subcategory').val();
		const uomId = $('#uoms').val();

		if (!name || isNaN(price) || price < 0
			|| isNaN(quantity) || !categoryId || !subcategoryId || !uomId) {
			return alert("Please fill out all fields correctly.");
		}

		// Disable save button to prevent duplicate submissions
		$btn.prop('disabled', true);

		// Build product payload
		const product = {
			id: parseInt($('#id').val(), 10),
			name,
			category_id: parseInt(categoryId, 10),
			subcategory_id: parseInt(subcategoryId, 10),
			uom_id: parseInt(uomId, 10),
			price,
			quantity
		};

		// Determine API endpoint: add vs update
		const url = product.id === 0 ? '/addProduct' : `/updateProduct/${product.id}`;

		$.ajax({
			url,
			method: 'POST',
			contentType: 'application/json',
			data: JSON.stringify(product),

			// -----------------------------------------------------------------------
			// SUCCESS HANDLER
			// -----------------------------------------------------------------------
			success() {
				$('#productModal').modal('hide');

				// Show contextual success message
				const msg = (product.id === 0)
					? 'Product added successfully.'
					: 'Product updated successfully.';

				$('#alert-container').html(`
					<div class="alert alert-success alert-dismissible fade show" role="alert">
						${msg}
						<button type="button" class="close" data-dismiss="alert" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
				`);

				// Auto-dismiss alert after 3s
				setTimeout(() => {
					$('.alert').alert('close');
				}, 3000);

				// Reset form & reload table
				resetForm();
				loadProducts();
			},  

			// -----------------------------------------------------------------------
			// ERROR HANDLER
			// -----------------------------------------------------------------------
			error(err) {
				alert('Error saving product: ' + err.responseText);
			},

			// -----------------------------------------------------------------------
			// COMPLETE (always re-enable button)
			// -----------------------------------------------------------------------
			complete() {
				$btn.prop('disabled', false);
			}
		});
	});

	// ---------------------------------------------------------------------------
	// PREFILL & SHOW EDIT MODAL
	// ---------------------------------------------------------------------------
	$(document).on('click', '.edit-btn', function () {
		const prod = $(this).data('product');

		// Populate form fields
		$('#id').val(prod.product_id);
		$('#name').val(prod.product_name);
		$('#price').val(prod.price_per_unit);
		$('#quantity').val(prod.quantity);

		// Load categories, then subcategories, then pre-select
		loadCategories(() => {
			$('#category').val(prod.category_id);
			loadSubcategories(prod.category_id, () => {
				$('#subcategory').val(prod.subcategory_id);
			});
		});

		// Load units and pre-select
		loadUOMs(() => {
			$('#uoms').val(prod.uom_id);
		});

		// Display modal
		$('#productModal').modal('show');
	});

	// ---------------------------------------------------------------------------
	// DELETE PRODUCT
	// ---------------------------------------------------------------------------
	$(document).on('click', '.delete-btn', function () {
		if (!confirm("Are you sure?")) return;
		const id = $(this).data('id');
		$.ajax({
			url: `/deleteProduct/${id}`,
			method: 'DELETE',
			success() {
				loadProducts();

				// Show warning alert for deletion
				$('#alert-container').html(`
					<div class="alert alert-warning alert-dismissible fade show" role="alert">
						Product deleted successfully.
						<button type="button" class="close" data-dismiss="alert" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
				`);

				// Scroll to top where alert lives
				$('html, body').animate({
					scrollTop: $('#alert-container').offset().top
				}, 'fast');

				// Auto-dismiss alert
				setTimeout(() => {
					$('.alert').alert('close');
				}, 3000);
			},

			error() {
				alert("Delete failed");
			}
		});
	});
});


// -----------------------------------------------------------------------------
// FETCH & RENDER PRODUCTS TABLE
// -----------------------------------------------------------------------------
function loadProducts() {
	$.get('/getProducts', products => {
		let rows = '';
		products.forEach(prod => {
			rows += `
        <tr>
          <td>${prod.product_name}</td>
          <td>${prod.category_name || ''}</td>
          <td>${prod.subcategory_name || ''}</td>
          <td>${prod.uom_name || ''}</td>
          <td>${prod.price_per_unit.toFixed(2)}</td>
          <td>${prod.quantity}</td>
          <td>
            <button class="btn btn-sm btn-info edit-btn"
                    data-product='${JSON.stringify(prod)}'>
              Edit
            </button>
            <button class="btn btn-sm btn-danger delete-btn" data-id="${prod.product_id}">
              Delete
            </button>
          </td>
        </tr>`;
		});
		$('#product-list').html(rows);
	}).fail(() => alert('Failed to load products.'));
}

// -----------------------------------------------------------------------------
// RESET FORM TO DEFAULT STATE
// -----------------------------------------------------------------------------
function resetForm() {
	$('#productForm')[0].reset();
	$('#id').val(0);

	// Reset subcategory dropdown
	$('#subcategory').html('<option value="">Select subcategory</option>');
}


// -----------------------------------------------------------------------------
// LOAD UNITS OF MEASURE (UOM)
// -----------------------------------------------------------------------------
let uomLoading = false;
function loadUOMs(callback) {
	if (uomLoading) return;
	uomLoading = true;
	$.get('/getUOMs', uoms => {
		let opts = '<option value=\"\">Select unit</option>';
		uoms.forEach(u => {
			opts += `<option value=\"${u.uom_id}\">${u.uom_name}</option>`;
		});
		$('#uoms').html(opts);
		if (callback) callback();
	}).always(() => { uomLoading = false; });
}

// -----------------------------------------------------------------------------
// LOAD CATEGORIES DROPDOWN
// -----------------------------------------------------------------------------
let catLoading = false;
function loadCategories(callback) {
	if (catLoading) return;
	catLoading = true;
	$.get('/getCategories', cats => {
		let opts = '<option value=\"\">Select category</option>';
		cats.forEach(c => {
			opts += `<option value=\"${c.category_id}\">${c.category_name}</option>`;
		});
		$('#category').html(opts);
		if (callback) callback();
	}).always(() => { catLoading = false; });
}

// -----------------------------------------------------------------------------
// LOAD SUBCATEGORIES FOR A GIVEN CATEGORY
// -----------------------------------------------------------------------------
function loadSubcategories(categoryId, callback) {
	if (!categoryId) {
		$('#subcategory').html('<option value=\"\">Select subcategory</option>');
		if (callback) callback();
		return;
	}
	
	$.get(`/getSubcategories?category_id=${categoryId}`, subs => {
		let opts = '<option value=\"\">Select subcategory</option>';
		subs.forEach(s => {
			opts += `<option value=\"${s.subcategory_id}\">${s.subcategory_name}</option>`;
		});
		$('#subcategory').html(opts);
		if (callback) callback();
	}).fail(() => alert('Failed to load subcategories.'));
}