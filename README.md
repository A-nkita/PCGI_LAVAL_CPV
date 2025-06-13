# Laval CPV – ETL Data Pipeline Project

## 🧠 Overview

This project involves the design and development of an automated ETL pipeline for the client **Laval**, aimed at extracting data from multiple Oracle-based systems, transforming it based on business logic, and loading it into an AWS Redshift data warehouse for reporting and analysis.

The pipeline supports **daily data refresh**, ensuring that business users have access to up-to-date, cleaned, and structured data through predefined views.

---

## 👩‍💻 Role & Team

- **Role**: ETL Developer  
- **Team Size**: 4  
- **Duration**: June 2024 – May 2025  
- **Client**: Laval  

---

## 🛠️ Tools & Technologies

- **Cloud**: AWS (EC2, S3, Lambda, Redshift)  
- **Languages**: Python, SQL  
- **Database**: Oracle, PostgreSQL, Redshift  
- **Others**: Excel  

---

## 🔄 ETL Process

### ✅ **Extraction**
- Source systems: Oracle (Glimps, MarsXP)
- Extracted using **Python scripts** running on **EC2**
- Data landed in **S3 buckets**

### 🔁 **Transformation**
- Business-provided logic used to transform data
- Performed **data cleaning**, **type conversions**, and **joins**
- Queries adapted and optimized for **Amazon Redshift**
- No fact/dimension modeling; followed **normalized structure**

### 📥 **Loading**
- Loading jobs triggered via **AWS Lambda**
- Created **Redshift views** (not physical tables) for reporting
- ETL load configuration managed using **PostgreSQL**

---

## 📈 Outcome

- Automated daily ETL process
- Centralized and structured data warehouse in Redshift
- Enabled downstream analytics teams to build reports based on consistent, business-aligned logic

---

## 📌 Notes

- The OLAP layer and data analysis were handled by a separate reporting team using the Redshift views created in this pipeline.
- This project focused strictly on the backend data engineering (ETL) side.

---

## 🙋‍♀️ Contributions

Developed and maintained by Ankita.  
Feel free to fork, clone, or reach out for collaboration ideas!

