# CRM
# CRM Application (ColdFusion)

## 📌 Project Overview

This project is a **CRM (Customer Relationship Management) web application** developed using **Adobe ColdFusion**. The application helps manage customers, users, and related CRM operations in a structured way using an MVC-style architecture.

The main goal of this project is to understand and implement:

* ColdFusion fundamentals
* MVC pattern
* Database connectivity
* User authentication
* Real-time CRUD operations
* Proper project structuring

---

## 🛠️ Technologies Used

* **Backend:** Adobe ColdFusion (CFML)
* **Frontend:** HTML, CSS, JavaScript
* **Database:** MySQL (via CFQuery)
* **Server:** ColdFusion Server (local)
* **Version Control:** Git & GitHub

---

## 📂 Project Structure

```
CRM/
│── application.cfc      # Application configuration & session management
│── controller.cfc       # Main controller handling business logic
│── router.cfm           # URL routing & request handling
│── index.cfm            # Application entry point
│── logout.cfm           # User logout logic
│── README.md            # Project documentation
│
├── components/           # CFC files (services, helpers)
├── views/                # UI pages (CFM files)
├── includes/             # Common reusable templates
├── css/                  # Stylesheets
├── scriptjs/             # JavaScript files
├── uploads/              # Uploaded files
├── Downloads/            # Downloaded reports / PDFs
├── scheduler/            # Scheduled task related files
```

---

## 🔑 Key Features Implemented

### ✅ User Authentication

* Login & logout functionality
* Session handling using `application.cfc`
* Admin and user role handling

### ✅ Customer Management

* Add new customers
* View customer list
* Edit customer details
* Delete customers

### ✅ MVC Architecture

* **Controller (`controller.cfc`)** handles all business logic
* **Views (`views/*.cfm`)** manage UI
* **Components (`components/*.cfc`)** handle database operations

### ✅ Database Integration

* Secure database access using `cfquery` and `cfqueryparam`
* Centralized datasource configuration

### ✅ File Handling

* Uploading files
* Download tracking (PDF / reports)

### ✅ Routing System

* Clean URL routing using `router.cfm`
* Centralized request handling

---

## 🚀 Git & GitHub Work Done

* Initialized Git repository locally
* Connected local CRM project to GitHub
* Managed version control using:

  ```bash
  git add .
  git commit -m "message"
  git push
  ```
* Successfully pushed full ColdFusion CRM project to GitHub

---

## 🧪 How to Run the Project

1. Install **Adobe ColdFusion Server**
2. Place the project inside:

   ```
   C:\ColdFusion2025\cfusion\wwwroot\CRM
   ```
3. Configure datasource in ColdFusion Administrator
4. Open browser and run:

   ```
   http://localhost:8500/CRM/
   ```

---

## 📈 Learning Outcomes

* Hands-on experience with ColdFusion MVC architecture
* Strong understanding of Git & GitHub workflow
* Real-time CRUD implementation
* Better project structuring for enterprise applications

---

## 👤 Author

**Lokesh Thanukonda**
CRM Application – ColdFusion Project

---

## 📌 Future Enhancements

* Pagination & search
* REST API integration
* UI improvements
* Role-based access control
* Email notifications
