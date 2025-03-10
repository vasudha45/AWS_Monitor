# AWS Cost Optimization Plugin 🚀

This project automates the process of **monitoring and optimizing AWS EC2 costs** by stopping unused or idle instances based on specific criteria. It uses **AWS services** such as **Lambda**, **CloudWatch**, and **SNS** to trigger actions and automate the cost-saving process. It also leverages **Terraform** to manage AWS resources.

## Features 🌟
- **Fetch AWS Cost Data**: Dynamically fetch AWS usage and cost data based on user-provided credentials.
- **Cost Optimization**: Use machine learning or simple algorithms to determine idle EC2 instances and stop them to save costs.
- **Dynamic AWS Integration**: Accept AWS credentials from the user to interact with AWS resources.
- **Terraform Integration**: Use Terraform to apply infrastructure changes and automate resource management.

---

## 🛠️ Technologies Used

- **AWS Services**:
  - EC2 (Elastic Compute Cloud)
  - Lambda
  - CloudWatch
  - SNS (Simple Notification Service)
  - IAM (Identity and Access Management)
  
- **Frontend**: 
  - HTML + JavaScript (User interface to enter AWS credentials)
  
- **Backend**:
  - Node.js (Backend API to handle requests and trigger optimization)

- **Infrastructure as Code**: 
  - Terraform (to manage AWS resources)

---

## 🚀 How It Works

1. **User Input** 📝: 
   - The user enters their AWS **Access Key**, **Secret Key**, **Region**, and **Email** in the provided form.
   
2. **Fetch Cost Data** 💰:
   - Once the user submits their credentials, the backend uses AWS SDK to fetch **cost and usage data** from AWS for the specified region.

3. **Cost Optimization Logic** 🤖:
   - The system analyzes the data, and based on a predefined threshold (e.g., CPU utilization < 5%), identifies idle EC2 instances.

4. **Triggering Optimization** ⚡:
   - Using **AWS Lambda**, **SNS**, and **CloudWatch**, the system automatically stops idle EC2 instances.
   - The backend triggers **Terraform** to apply the changes.

---

## 🏁 Getting Started

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/yourusername/aws-cost-optimization.git
```

### 2. Install Dependencies

Make sure you have **Node.js** installed. Run the following command to install backend dependencies:

```bash
npm install
```

For Terraform, make sure you have it installed on your system:

```bash
terraform -v
```

If you haven't installed Terraform yet, follow the installation guide [here](https://www.terraform.io/downloads.html).

### 3. Configure AWS Credentials

Ensure your AWS credentials (Access Key, Secret Key, and Region) are provided when submitting the form in `index.html`. These credentials are required for accessing AWS services.

### 4. Start the Backend Server

In the project directory, start the backend server:

```bash
node index.js
```

The backend will run on `http://localhost:5000`.

### 5. Open the Frontend

Open the `index.html` file in your browser, fill out your AWS credentials, and click the **Enable Optimization** button.

### 6. Run Terraform

Once you configure your Terraform resources and have your credentials set up, run Terraform to manage the resources:

```bash
terraform init
terraform apply -auto-approve
```

This will create the necessary AWS resources defined in the Terraform files.

---
![WhatsApp Image 2025-03-11 at 00 42 32_641f4a8d](https://github.com/user-attachments/assets/629132f1-056f-4c0b-b49c-73b6dabb5f63)



## 📈 Future Improvements
- **Real-time Email Alerts**: Send email notifications when optimizations are triggered.
- **Advanced Machine Learning**: Implement machine learning models to better analyze cost data and make smarter optimization decisions.
- **User Authentication**: Implement a login system to securely manage AWS credentials and provide optimized, user-specific suggestions.
- **Graphical Dashboards**: Add data visualizations for better understanding of AWS usage and optimization savings.

---

## 🤝 Contributing

Feel free to fork this project and submit **Pull Requests**. If you have any issues or feature requests, please create an **Issue** in the GitHub repository.
