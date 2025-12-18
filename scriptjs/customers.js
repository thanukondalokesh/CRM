const api = "/CRM/controller.cfc";


let currentPage = 1;
let pageSize = 5;

function escapeHTML(t) {
    return t?.replace(/[&<>"']/g, m => ({
        "&": "&amp;", "<": "&lt;", ">": "&gt;",
        '"': "&quot;", "'": "&#039;"
    })[m]);
}

async function loadCustomers() {
    const search = document.getElementById("searchBox").value || "";

    const res = await fetch(
        `${api}?method=getCustomers&returnformat=json&page=${currentPage}&pageSize=${pageSize}&search=${encodeURIComponent(search)}`
    );

    const result = await res.json();

    const tbody = document.getElementById("customerTable");
    tbody.innerHTML = "";

    result.data.forEach(c => {
        tbody.innerHTML += `
            <tr>
                <td>${c.id}</td>
                <td>${escapeHTML(c.username)}</td>
                <td>${escapeHTML(c.name)}</td>
                <td>${escapeHTML(c.email)}</td>
                <td>${escapeHTML(c.phone)}</td>
                <td>
                    <button class="action-btn btn-edit" onclick="editCustomer(${c.id})">Edit</button>
                    <button class="action-btn btn-delete" onclick="deleteCustomer(${c.id})">Delete</button>
                </td>
            </tr>`;
    });

    updatePagination(result.total);
}

function updatePagination(totalRecords) {
    const totalPages = Math.ceil(totalRecords / pageSize);
    const p = document.getElementById("pagination");

    let html = `<div class="pagination">`;

    // Previous
    html += `
        <button class="page-btn" 
            ${currentPage === 1 ? "disabled" : ""} 
            onclick="gotoPage(${currentPage - 1})">
            Previous
        </button>`;

    // Page numbers
    for (let i = 1; i <= totalPages; i++) {
        html += `
            <button 
                class="page-btn ${i === currentPage ? "active" : ""}" 
                onclick="gotoPage(${i})">
                ${i}
            </button>`;
    }

    // Next
    html += `
        <button class="page-btn" 
            ${currentPage === totalPages ? "disabled" : ""} 
            onclick="gotoPage(${currentPage + 1})">
            Next
        </button>`;

    html += `</div>`;
    p.innerHTML = html;
}


function gotoPage(page) {
    currentPage = page;
    loadCustomers();
}

async function saveCustomer(e) {
    e.preventDefault();

    let name = document.getElementById("name").value.trim();
    let email = document.getElementById("email").value.trim();
    let phone = document.getElementById("phone").value.trim();

    let check = await fetch(`${api}?method=emailExists&email=${encodeURIComponent(email)}&returnformat=json`);
    check = await check.json();

    if (check.exists) {
        showEmailPopup();
        return;
    }

    let formData = new FormData();
    formData.append("method", "saveCustomer");
    formData.append("name", name);
    formData.append("email", email);
    formData.append("phone", phone);

    let res = await fetch(api, { method: "POST", body: formData });
    let result = await res.json();

    alert(result.message);
    resetForm();
    loadCustomers();
}

async function editCustomer(id) {
    const res = await fetch(`${api}?method=getCustomer&id=${id}&returnformat=json`);
    const c = await res.json();

    document.getElementById("edit_id").value = c.id;
    document.getElementById("edit_name").value = c.name;
    document.getElementById("edit_email").value = c.email;
    document.getElementById("edit_phone").value = c.phone;

    document.getElementById("editModal").style.display = "flex";
}

function closeModal() {
    document.getElementById("editModal").style.display = "none";
}

async function updateCustomer() {
    const id = document.getElementById("edit_id").value;
    const name = document.getElementById("edit_name").value.trim();
    const email = document.getElementById("edit_email").value.trim();
    const phone = document.getElementById("edit_phone").value.trim();

    let formData = new FormData();
    formData.append("method", "saveCustomer");
    formData.append("id", id);
    formData.append("name", name);
    formData.append("email", email);
    formData.append("phone", phone);

    let res = await fetch(api, { method: "POST", body: formData });
    let result = await res.json();

    alert(result.message);
    closeModal();
    loadCustomers();
}

async function deleteCustomer(id) {
    if (!confirm("Are you sure?")) return;

    const res = await fetch(`${api}?method=deleteCustomer&id=${id}&returnformat=json`);
    const result = await res.json();

    alert(result.message);
    loadCustomers();
}

function resetForm() {
    document.getElementById("customerForm").reset();
}

function showEmailPopup() {
    document.getElementById("emailExistsModal").style.display = "flex";
}

function closeEmailPopup() {
    document.getElementById("emailExistsModal").style.display = "none";
}

function clearSearch() {
    document.getElementById("searchBox").value = "";
    loadCustomers();
}

window.onload = loadCustomers;
