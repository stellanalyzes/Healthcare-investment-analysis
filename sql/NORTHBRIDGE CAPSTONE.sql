----CREATING TABLES

CREATE TABLE ECH(
encounter_id VARCHAR(50) PRIMARY KEY,
claim_id VARCHAR(50),
patient_id VARCHAR(50),
hospital_name VARCHAR(50),
hospital_code VARCHAR(50),
hospital_type VARCHAR(50),
hospital_city VARCHAR(50),
total_licensed_beds INT,
patient_age INT,
patient_gender VARCHAR(10),
provider_id VARCHAR(50),
provider_name VARCHAR(50),
admission_type VARCHAR(50),
department VARCHAR(50),
severity_level INT,
admission_date DATE,
discharge_date DATE,
ed_arrival_time TIMESTAMP,
provider_seen_time TIMESTAMP,
diagnosis_code VARCHAR(10),
diagnosis_description VARCHAR(50),
procedure_code VARCHAR(50),
procedure_description VARCHAR(50),
outcome VARCHAR(50),
discharge_disposition VARCHAR(50),
complication_flag INT,
complication_type VARCHAR(50),
hospital_acquired_infection INT,
quality_incident VARCHAR(50),
mortality_flag INT,
patient_satisfaction_score FLOAT,
payer_type VARCHAR(50),
billed_amount FLOAT,
allowed_amount FLOAT,
paid_amount FLOAT,
claim_status VARCHAR(50),
denial_reason VARCHAR(50),
claim_submission_date DATE,
claim_processing_days INT
);

CREATE TABLE RMC(
encounter_id VARCHAR(50) PRIMARY KEY,
claim_id VARCHAR(50),
patient_id VARCHAR(50),
hospital_name VARCHAR(50),
hospital_code VARCHAR(50),
hospital_type VARCHAR(50),
hospital_city VARCHAR(50),
total_licensed_beds INT,
patient_age INT,
patient_gender VARCHAR(10),
provider_id VARCHAR(50),
provider_name VARCHAR(50),
admission_type VARCHAR(50),
department VARCHAR(50),
severity_level INT,
admission_date DATE,
discharge_date DATE,
ed_arrival_time TIMESTAMP,
provider_seen_time TIMESTAMP,
diagnosis_code VARCHAR(10),
diagnosis_description VARCHAR(50),
procedure_code VARCHAR(50),
procedure_description VARCHAR(50),
outcome VARCHAR(50),
discharge_disposition VARCHAR(50),
complication_flag INT,
complication_type VARCHAR(50),
hospital_acquired_infection INT,
quality_incident VARCHAR(50),
patient_satisfaction_score FLOAT,
payer_type VARCHAR(50),
billed_amount FLOAT,
allowed_amount FLOAT,
paid_amount FLOAT,
claim_status VARCHAR(50),
denial_reason VARCHAR(50),
claim_submission_date DATE,
claim_processing_days INT
);

CREATE TABLE GGH(
encounter_id VARCHAR(50) PRIMARY KEY,
claim_id VARCHAR(50),
patient_id VARCHAR(50),
hospital_name VARCHAR(50),
hospital_code VARCHAR(50),
hospital_type VARCHAR(50),
hospital_city VARCHAR(50),
total_licensed_beds INT,
patient_age INT,
patient_gender VARCHAR(10),
provider_id VARCHAR(50),
provider_name VARCHAR(50),
admission_type VARCHAR(50),
department VARCHAR(50),
severity_level INT,
admission_date DATE,
discharge_date DATE,
ed_arrival_time TIMESTAMP,
provider_seen_time TIMESTAMP,
diagnosis_code VARCHAR(10),
diagnosis_description VARCHAR(50),
procedure_code VARCHAR(50),
procedure_description VARCHAR(50),
outcome VARCHAR(50),
discharge_disposition VARCHAR(50),
complication_flag INT,
complication_type VARCHAR(50),
hospital_acquired_infection INT,
quality_incident VARCHAR(50),
patient_satisfaction_score FLOAT,
payer_type VARCHAR(50),
billed_amount FLOAT,
allowed_amount FLOAT,
paid_amount FLOAT,
claim_status VARCHAR(50),
denial_reason VARCHAR(50),
claim_submission_date DATE,
claim_processing_days INT
);

SELECT *
FROM ECH

SELECT *
FROM GGH

SELECT *
FROM RMC

CREATE VIEW Master_hospital_analytics AS

WITH hospital_data_combined AS (
   
    -- 1. Eastpoint Community Hospital (ECH)
    SELECT 
        hospital_code, hospital_name, hospital_type, hospital_city, total_licensed_beds,
        encounter_id, claim_id, patient_id, patient_age, patient_gender,
        provider_id, provider_name, admission_type, department, severity_level, 
        admission_date, discharge_date, ed_arrival_time, provider_seen_time,
        outcome, complication_flag, complication_type, hospital_acquired_infection, quality_incident, 
        mortality_flag, 
        patient_satisfaction_score, payer_type, billed_amount, allowed_amount, paid_amount, 
        claim_status, denial_reason, claim_submission_date, claim_processing_days
    FROM ECH
    
    UNION ALL
    
    -- 2. Greenfield General Hospital (GGH)
    SELECT 
        hospital_code, hospital_name, hospital_type, hospital_city, total_licensed_beds,
        encounter_id, claim_id, patient_id, patient_age, patient_gender,
        provider_id, provider_name, admission_type, department, severity_level, 
        admission_date, discharge_date, ed_arrival_time, provider_seen_time,
        outcome, complication_flag,complication_type, hospital_acquired_infection, quality_incident, 
        -- Derive mortality flag for GGH based on clinical status
        CASE WHEN LOWER(TRIM(outcome)) = 'expired' THEN 1 ELSE 0 END AS mortality_flag,
        patient_satisfaction_score, payer_type, billed_amount, allowed_amount, paid_amount, 
        claim_status, denial_reason, claim_submission_date, claim_processing_days
    FROM GGH
    
    UNION ALL
    
    -- 3. Riverside Medical Centre (RMC)
    SELECT 
        hospital_code, hospital_name, hospital_type, hospital_city, total_licensed_beds,
        encounter_id, claim_id, patient_id, patient_age, patient_gender,
        provider_id, provider_name, admission_type, department, severity_level, 
        admission_date, discharge_date, ed_arrival_time, provider_seen_time,
        outcome, complication_flag, complication_type, hospital_acquired_infection, quality_incident, 
        -- Derive mortality flag for RMC based on clinical status
        CASE WHEN LOWER(TRIM(outcome)) = 'expired' THEN 1 ELSE 0 END AS mortality_flag,
        patient_satisfaction_score, payer_type, billed_amount, allowed_amount, paid_amount, 
        claim_status, denial_reason, claim_submission_date, claim_processing_days
    FROM RMC
)

-----------------------------------------------------------------------------
--DATA CLEANING
-----------------------------------------------------------------------------
SELECT
    hospital_code, 
    hospital_name, 
    hospital_type, 
    hospital_city, 
    total_licensed_beds,
    encounter_id, 
    claim_id, 
    patient_id, 
    patient_age,
    
    --Clean Patient Gender
    CASE 
        WHEN UPPER(TRIM(patient_gender)) LIKE 'M%' THEN 'MALE'
        WHEN UPPER(TRIM(patient_gender)) LIKE 'F%' THEN 'FEMALE'
    END AS patient_gender,
    
    provider_id,
    
    --Standardize Provider Names 
    CASE provider_id
        WHEN 'DR-ECH-001' THEN 'Dr. Abena Mensah-Bonsu'
        WHEN 'DR-ECH-002' THEN 'Dr. Carlos Mendoza'
        WHEN 'DR-ECH-003' THEN 'Dr. Dami Adesanya'
        WHEN 'DR-ECH-004' THEN 'Dr. Fatou Diallo'
        WHEN 'DR-ECH-005' THEN 'Dr. Henrik Larsson'
        WHEN 'DR-ECH-006' THEN 'Dr. Ifeoma Eze'
        WHEN 'DR-ECH-007' THEN 'Dr. Jonas Weber'
        WHEN 'DR-ECH-008' THEN 'Dr. Nkechi Okonkwo'
        WHEN 'DR-GGH-001' THEN 'Dr. Amelia Hoffmann'
        WHEN 'DR-GGH-002' THEN 'Dr. Babatunde Oladele'
        WHEN 'DR-GGH-003' THEN 'Dr. Chloe Beaumont'
        WHEN 'DR-GGH-004' THEN 'Dr. Ekundayo Fashola'
        WHEN 'DR-GGH-005' THEN 'Dr. Miriam Vandenberg'
        WHEN 'DR-GGH-006' THEN 'Dr. Olumide Sotayo'
        WHEN 'DR-GGH-007' THEN 'Dr. Priya Krishnamurthy'
        WHEN 'DR-GGH-008' THEN 'Dr. Rashid Al-Farouq'
        WHEN 'DR-RMC-001' THEN 'Dr. Adaora Nwachukwu'
        WHEN 'DR-RMC-002' THEN 'Dr. Brendan Callahan'
        WHEN 'DR-RMC-003' THEN 'Dr. Chinonso Obiechina'
        WHEN 'DR-RMC-004' THEN 'Dr. Giulia Ferrante'
        WHEN 'DR-RMC-005' THEN 'Dr. Kwabena Asumadu'
        WHEN 'DR-RMC-006' THEN 'Dr. Linh Nguyen'
        WHEN 'DR-RMC-007' THEN 'Dr. Mubarak Essien'
        WHEN 'DR-RMC-008' THEN 'Dr. Vera Johansson'
        ELSE INITCAP(TRIM(provider_name))
    END AS provider_name,
    
    -- Standardize Admission Type 
    INITCAP(TRIM(admission_type)) AS admission_type,
    
    -- Clean Department Names 
    CASE 
        WHEN LOWER(TRIM(department)) IN ('gen surge', 'general surgery') THEN 'General Surgery'
        WHEN LOWER(TRIM(department)) IN ('orthopedics', 'orthopaedics') THEN 'Orthopedics'
        WHEN LOWER(TRIM(department)) = 'CARDIOLOGY' THEN 'Cardiology'
        WHEN LOWER(TRIM(department)) IN ('Internal Medicine', 'Int.Medicine', 'Intmed')
             THEN 'Internal Medicine'
        WHEN LOWER(TRIM(department)) IN ('Emergency Medicne', 'EMERGENCY')
             THEN 'Emergency Medicine'
        WHEN LOWER(TRIM(department)) IN ('GENERAL SURGERY', 'GEN SURGE', 'SURGERY')
             THEN 'General Surgery'
        WHEN LOWER(TRIM(department)) = 'NEUROLOGY'
             THEN 'Neurology'
        WHEN LOWER(TRIM(department)) = 'ORTHOPEDICS'
             THEN 'Orthopedics'
        WHEN LOWER(TRIM(department)) = 'PEDIATRICS'
             THEN 'Pediatrics'
        WHEN LOWER(TRIM(department)) IN ('OBSTETRICS & GYNECOLOGY', 'OBSTETRICS &AMP; GYNECOLOGY')
             THEN 'Obstetrics & Gynecology'
        ELSE INITCAP(TRIM(department))
    END AS department,
    severity_level, 
    admission_date, 
    discharge_date, 
    ed_arrival_time, 
    provider_seen_time,
    outcome, 
    complication_flag, 
	complication_type,
    hospital_acquired_infection,
    quality_incident,
    mortality_flag, 
    patient_satisfaction_score, 
    payer_type,
   	billed_amount,
   	allowed_amount,
   	paid_amount,
	   
	--Standardize Claim Status 
    CASE 
        WHEN LOWER(TRIM(claim_status)) IN ('Appeal','Appealing','Appell','appealed','Under Appealling', 'Under Under Appeal','appealing', 'under appeal') THEN 'Under Appeal'
        ELSE INITCAP(TRIM(claim_status))
    END AS claim_status, 
	denial_reason,
    claim_submission_date, 
    claim_processing_days,
	
	--- DERIVED OPERATION METRICS
	---Length of stay
    (discharge_date - admission_date) AS LOS,
    CASE 
        WHEN ed_arrival_time IS NOT NULL AND provider_seen_time IS NOT NULL 
        THEN EXTRACT(EPOCH FROM (provider_seen_time - ed_arrival_time)) / 60 
        ELSE NULL 
    END AS ed_wait_time_minutes,

	-- Revenue gap = what was billed but not collected
    (Hospital_data_combined.billed_amount - Hospital_data_combined.paid_amount) AS revenue_gap,

    -- Binary indicator flags for efficient aggregation
    CASE WHEN UPPER(TRIM(Hospital_data_combined.claim_status)) = 'PAID'         THEN 1 ELSE 0 END AS is_paid,
    CASE WHEN UPPER(TRIM(Hospital_data_combined.claim_status)) = 'DENIED'       THEN 1 ELSE 0 END AS is_denied,
    CASE WHEN UPPER(TRIM(Hospital_data_combined.claim_status)) = 'UNDER APPEAL' THEN 1 ELSE 0 END AS is_under_appeal,

    -- Time dimensions for trend analysis
    EXTRACT(YEAR  FROM Hospital_data_combined.admission_date)::INTEGER        AS admission_year,
    EXTRACT(MONTH FROM Hospital_data_combined.admission_date)::INTEGER        AS admission_month,
    DATE_TRUNC('month', Hospital_data_combined.admission_date)                AS admission_month_dt,
    DATE_TRUNC('quarter', Hospital_data_combined.admission_date)              AS admission_quarter_dt,

    -- Age bands for demographic segmentation
    CASE 
        WHEN Hospital_data_combined.patient_age < 18  THEN '0-17 (Pediatric)'
        WHEN Hospital_data_combined.patient_age BETWEEN 18 AND 34 THEN '18-34 (Young Adult)'
        WHEN Hospital_data_combined.patient_age BETWEEN 35 AND 50 THEN '35-50 (Adult)'
        WHEN Hospital_data_combined.patient_age BETWEEN 51 AND 64 THEN '51-64 (Middle-Aged)'
        ELSE '65+ (Senior)'
    END AS age_band,

    -- Severity label 
    CASE Hospital_data_combined.severity_level
        WHEN 1 THEN '1 - Minor'
        WHEN 2 THEN '2 - Low'
        WHEN 3 THEN '3 - Moderate'
        WHEN 4 THEN '4 - High'
        WHEN 5 THEN '5 - Critical'
        ELSE 'Unknown'
    END AS severity_label
	
FROM Hospital_data_combined;

--DATA QUALITY AUDIT 

-- Check 1: Negative length of stay (discharge before admission)
SELECT 
    hospital_code, encounter_id, patient_id, admission_date, discharge_date, LOS
FROM Master_hospital_analytics
WHERE LOS < 0;

-- Check 2: Paid amount greater than billed amount
SELECT 
    hospital_code, claim_id, billed_amount, allowed_amount, paid_amount,
    (paid_amount - billed_amount) AS overpayment_variance
FROM Master_hospital_analytics
WHERE paid_amount > billed_amount;

-- Check 3: Claim marked Denied but paid amount > 0 
SELECT 
    hospital_code, claim_id, claim_status, paid_amount, denial_reason
FROM Master_hospital_analytics
WHERE claim_status = 'Denied' AND paid_amount > 0;

-- Check 4: Mortality flag = 1 but outcome is not 'Expired' 
SELECT 
    hospital_code, 
    encounter_id, 
    outcome, 
    mortality_flag
FROM Master_hospital_analytics
WHERE mortality_flag = 1 
  AND LOWER(TRIM(outcome)) != 'expired';

-- Check 5: ED timestamps present for Urgent/Elective admissions (should only be Emergency)
SELECT 
    hospital_code, encounter_id, admission_type, ed_arrival_time, provider_seen_time
FROM Master_hospital_analytics
WHERE admission_type IN ('Elective', 'Urgent') 
  AND (ed_arrival_time IS NOT NULL OR provider_seen_time IS NOT NULL);

-- Check 6: severity_level values outside valid range 1-5
SELECT 
    hospital_code, encounter_id, severity_level
FROM Master_hospital_analytics
WHERE severity_level < 1 OR severity_level > 5 OR severity_level IS NULL;


SELECT *
FROM master_hospital_analytics

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- — ANALYTICAL QUERIES
-------------------------------------------------------------------------
-------------------------------------------------------------------------


---MASTER KPI SUMMARY



SELECT 
    hospital_code,
    MAX(hospital_name) AS hospital_name,
    MAX(total_licensed_beds) AS licensed_beds,
    COUNT(*) AS total_encounters
FROM Master_hospital_analytics
GROUP BY hospital_code
ORDER BY total_encounters DESC;


--FINANCIAL PERFORMANCE

SELECT 
    hospital_code,
    MAX(hospital_name) AS hospital_name,
    SUM(billed_amount) AS total_billed,
    SUM(allowed_amount) AS total_allowed,
    SUM(paid_amount) AS total_revenue,
    ROUND(AVG(paid_amount)::NUMERIC, 2) AS avg_revenue_per_encounter,
    -- Collection KPIs
    ROUND((SUM(paid_amount) / NULLIF(SUM(billed_amount), 0) * 100)::NUMERIC, 2) AS gross_collection_rate_pct,
    ROUND((SUM(paid_amount) / NULLIF(SUM(allowed_amount), 0) * 100)::NUMERIC, 2) AS allowed_collection_rate_pct
FROM Master_hospital_analytics
GROUP BY hospital_code
ORDER BY total_revenue DESC;

    ----Revenue Leakage & Claims Funnel
SELECT 
    hospital_code,
    MAX(hospital_name) AS hospital_name,
    ROUND((COUNT(CASE WHEN is_denied = 1 THEN 1 END) / COUNT(*)::NUMERIC * 100), 2) AS denial_rate_pct,
    ROUND((COUNT(CASE WHEN is_paid = 1 THEN 1 END) / COUNT(*)::NUMERIC * 100), 2) AS payment_rate_pct,
    ROUND((COUNT(CASE WHEN is_under_appeal = 1 THEN 1 END) / COUNT(*)::NUMERIC * 100), 2) AS pending_appeal_rate_pct,
    ROUND(AVG(claim_processing_days)::NUMERIC, 1) AS avg_claim_processing_days,
    -- Capital At Risk
    SUM(CASE WHEN is_denied = 1 THEN (billed_amount - paid_amount) ELSE 0 END) AS denied_revenue_at_risk,
    SUM(CASE WHEN is_under_appeal = 1 THEN (billed_amount - paid_amount) ELSE 0 END) AS pending_revenue_at_risk
FROM Master_hospital_analytics
GROUP BY hospital_code
ORDER BY denied_revenue_at_risk DESC;


--CLINICAL QUALITY

SELECT 
    hospital_code,
    MAX(hospital_name) AS hospital_name,
    ROUND((SUM(mortality_flag) / COUNT(*)::NUMERIC * 100), 2) AS mortality_rate_pct,
    ROUND((COUNT(CASE WHEN complication_flag = 1 THEN 1 END) / COUNT(*)::NUMERIC * 100), 2) AS complication_rate_pct,
    ROUND((SUM(hospital_acquired_infection) / COUNT(*)::NUMERIC * 100), 2) AS hai_rate_pct,
    ROUND((COUNT(CASE WHEN LOWER(TRIM(outcome)) = 'readmitted' THEN 1 END) / COUNT(*)::NUMERIC * 100), 2) AS readmission_rate_pct,
    ROUND((COUNT(CASE WHEN LOWER(TRIM(outcome)) = 'recovered' THEN 1 END) / COUNT(*)::NUMERIC * 100), 2) AS recovery_rate_pct,
    ROUND((COUNT(CASE WHEN LOWER(TRIM(outcome)) = 'expired' THEN 1 END) / COUNT(*)::NUMERIC * 100), 2) AS expired_rate_pct
FROM Master_hospital_analytics
GROUP BY hospital_code
ORDER BY mortality_rate_pct ASC;

---OPERATIONAL EFFICIENCY
    
	SELECT 
    hospital_code,
    MAX(hospital_name) AS hospital_name,
    
    --Core Length of Stay Metrics 
    ROUND(AVG(LOS)::NUMERIC, 1) AS avg_los_days,
    MIN(LOS) AS minimum_los,
    MAX(LOS) AS max_los,
    
    --Emergency Front-Door Pressure
    ROUND(AVG(ed_wait_time_minutes)::NUMERIC, 1) AS avg_ed_wait_minutes,
    COUNT(CASE WHEN admission_type = 'Emergency' THEN 1 END) AS emergency_encounters,
    
    --Asset Throughput Velocity 
    ROUND((COUNT(*) / NULLIF(MAX(total_licensed_beds), 0)::NUMERIC), 2) AS encounters_per_bed_per_year,

    
    --Clinical context and severity mix
   
    -- Average sickness level on a scale of 1-5
    ROUND(AVG(severity_level)::NUMERIC, 2) AS avg_patient_severity,
    
    -- High Acuity Volume: Total count of severe cases (levels 4 & 5)
    COUNT(CASE WHEN severity_level >= 4 THEN 1 END) AS high_acuity_encounters_count,
    
    -- High Acuity Mix: Percentage of total patients who are severe
    ROUND((COUNT(CASE WHEN severity_level >= 4 THEN 1 END) / COUNT(*)::NUMERIC * 100), 2) AS high_acuity_mix_pct,

    --Doctor's workload
   
    -- Total active doctors deployed at the facility
    COUNT(DISTINCT provider_id) AS active_physician_count,
    
    -- Total case volume managed across the facility
    COUNT(*) AS total_encounters,
    
    -- Average patient load per physician
    ROUND((COUNT(*) / NULLIF(COUNT(DISTINCT provider_id), 0)::NUMERIC), 1) AS avg_encounters_per_doctor

FROM Master_hospital_analytics
GROUP BY hospital_code
ORDER BY avg_los_days ASC;

-- PATIENT EXPERIENCE
 
SELECT 
    hospital_code,
    MAX(hospital_name) AS hospital_name,
    ROUND(AVG(patient_satisfaction_score)::NUMERIC, 2) AS avg_satisfaction_score,
    MIN(patient_satisfaction_score) AS min_satisfaction,
    MAX(patient_satisfaction_score) AS max_satisfaction
FROM Master_hospital_analytics
GROUP BY hospital_code
ORDER BY avg_satisfaction_score DESC;

-- ============================================================
-- REVENUE TREND & YEAR-OVER-YEAR GROWTH
-- Measures financial trajectory 2022 → 2023 to Highlight growth trajectories and volume velocity
-- ============================================================
WITH yearly_metrics AS (
    SELECT
        hospital_code,
        MAX(hospital_name)   AS hospital_name,
        admission_year,
        COUNT(*)             AS encounters,
        SUM(billed_amount)   AS billed,
        SUM(paid_amount)     AS revenue,
        AVG(paid_amount)     AS avg_rev_per_encounter
    FROM Master_hospital_analytics
    GROUP BY hospital_code, admission_year
)
SELECT
    hospital_code,
    hospital_name,
    admission_year,
    encounters,

    ROUND(billed::NUMERIC,   0)   AS total_billed,
    ROUND(revenue::NUMERIC,  0)   AS total_revenue,
    ROUND(avg_rev_per_encounter::NUMERIC, 2) AS avg_rev_per_encounter,

    -- YoY revenue growth calculations
    ROUND(LAG(revenue) OVER (PARTITION BY hospital_code ORDER BY admission_year)::NUMERIC, 0) AS prev_year_revenue,
    ROUND(
        ((revenue - LAG(revenue) OVER (PARTITION BY hospital_code ORDER BY admission_year))
        / NULLIF(LAG(revenue) OVER (PARTITION BY hospital_code ORDER BY admission_year), 0) * 100)::NUMERIC,
        2
    ) AS revenue_yoy_growth_pct,

    -- YoY encounter volume growth calculations
    LAG(encounters) OVER (PARTITION BY hospital_code ORDER BY admission_year) AS prev_year_encounters,
    ROUND(
        (((encounters - LAG(encounters) OVER (PARTITION BY hospital_code ORDER BY admission_year))::FLOAT
        / NULLIF(LAG(encounters) OVER (PARTITION BY hospital_code ORDER BY admission_year), 0)) * 100)::NUMERIC,
        2
    ) AS encounter_yoy_growth_pct

FROM yearly_metrics
ORDER BY hospital_code, admission_year;


-- ============================================================
-- CLAIM STATUS BREAKDOWN 
-- ============================================================

WITH claim_counts_base AS (

    SELECT
        hospital_code,
        claim_status,
        COUNT(*) AS claim_count,
        SUM(billed_amount) AS billed,
        SUM(allowed_amount) AS allowed,
        SUM(paid_amount) AS paid,
        AVG(claim_processing_days) AS avg_days
    FROM Master_hospital_analytics
    GROUP BY hospital_code, claim_status
)

SELECT
    hospital_code,
    (SELECT MAX(hospital_name) FROM Master_hospital_analytics m WHERE m.hospital_code = c.hospital_code) AS hospital_name,
    claim_status,
    claim_count,
    

    ROUND(
        (claim_count::FLOAT / SUM(claim_count) OVER (PARTITION BY hospital_code) * 100)::NUMERIC, 
        2
    ) AS pct_of_hospital_claims,
    
    ROUND(billed::NUMERIC,  0) AS total_billed,
    ROUND(allowed::NUMERIC, 0) AS total_allowed,
    ROUND(paid::NUMERIC,    0) AS total_paid,
    ROUND(avg_days::NUMERIC, 1) AS avg_processing_days

FROM claim_counts_base c
ORDER BY hospital_code, claim_count DESC;

-- ============================================================
-- PAYER MIX ANALYSIS 
-- To Understand revenue source diversification and collection risks
-- ============================================================

WITH payer_metrics_base AS (
    -- Step 1: Pre-aggregate raw volumes, financial fields, and metrics per payer
    SELECT
        hospital_code,
        payer_type,
        COUNT(*) AS encounters,
        SUM(billed_amount) AS total_billed,
        SUM(paid_amount) AS total_paid,
        SUM(is_denied) AS total_denied_claims
    FROM Master_hospital_analytics
    GROUP BY hospital_code, payer_type
)
-- Step 2: Calculation of window percentages, collection rates, and denial rates
SELECT
    hospital_code,
    (SELECT MAX(hospital_name) FROM Master_hospital_analytics m WHERE m.hospital_code = p.hospital_code) AS hospital_name,
    payer_type,
    encounters,
    
    -- Window ratio for payer volume mix
    ROUND(
        (encounters::FLOAT / SUM(encounters) OVER (PARTITION BY hospital_code) * 100)::NUMERIC, 
        2
    ) AS pct_of_encounters,
    
    ROUND(total_billed::NUMERIC, 0) AS total_billed,
    ROUND(total_paid::NUMERIC,   0) AS total_paid,
    
    -- COLLECTION rate per payer type
    ROUND(
        (total_paid / NULLIF(total_billed, 0) * 100)::NUMERIC, 
        2
    ) AS payer_collection_rate_pct,
    
    -- Denial risk tracking per insurance 
    ROUND(
        (total_denied_claims::FLOAT / NULLIF(encounters, 0) * 100)::NUMERIC, 
        2
    ) AS payer_denial_rate_pct

FROM payer_metrics_base p
ORDER BY hospital_code, encounters DESC;

-- ============================================================
-- CLINICAL QUALITY METRICS 
-- Measure patient safety outcomes per hospital
-- ============================================================

SELECT
    hospital_code,
    MAX(hospital_name) AS hospital_name, 
    COUNT(*) AS total_encounters,

    -------------------------------------------------------------------------
    --CORE SAFETY INDICATORS
    -------------------------------------------------------------------------
    SUM(mortality_flag) AS total_deaths,
    ROUND((AVG(mortality_flag) * 100)::NUMERIC, 2) AS mortality_rate_pct,
    
    SUM(complication_flag) AS total_complications,
    ROUND((AVG(complication_flag) * 100)::NUMERIC, 2) AS complication_rate_pct,
    
    SUM(hospital_acquired_infection) AS total_hai,
    ROUND((AVG(hospital_acquired_infection) * 100)::NUMERIC, 2) AS hai_rate_pct,

    -------------------------------------------------------------------------
    --CLINICAL OUTCOME MIX
    -------------------------------------------------------------------------
    COUNT(CASE WHEN LOWER(TRIM(outcome)) = 'readmitted' THEN 1 END) AS total_readmissions,
    ROUND(
        (COUNT(CASE WHEN LOWER(TRIM(outcome)) = 'readmitted' THEN 1 END)::FLOAT / COUNT(*) * 100)::NUMERIC, 
        2
    ) AS readmission_rate_pct,
    
    COUNT(CASE WHEN LOWER(TRIM(outcome)) = 'recovered' THEN 1 END) AS total_recovered,
    ROUND(
        (COUNT(CASE WHEN LOWER(TRIM(outcome)) = 'recovered' THEN 1 END)::FLOAT / COUNT(*) * 100)::NUMERIC, 
        2
    ) AS recovery_rate_pct,

    -------------------------------------------------------------------------
    --OPERATIONAL QUALITY & EXPERIENCE
    -------------------------------------------------------------------------
    COUNT(CASE WHEN quality_incident != 'No Incident' THEN 1 END) AS total_quality_incidents,
    ROUND(
        (COUNT(CASE WHEN quality_incident != 'No Incident' THEN 1 END)::FLOAT / COUNT(*) * 100)::NUMERIC, 
        2
    ) AS quality_incident_rate_pct,

    ROUND(AVG(patient_satisfaction_score)::NUMERIC, 2) AS avg_satisfaction

FROM Master_hospital_analytics
GROUP BY hospital_code
ORDER BY hospital_code;


-- ============================================================
--COMPLICATION TYPE BREAKDOWN 
--Understand which complications drive quality risk
-- ============================================================

WITH complication_base AS (
    -- Step 1: Filter for complications and pre-aggregate counts and averages
    SELECT
        hospital_code,
        complication_type,
        COUNT(*) AS complication_count,
        SUM(LOS) AS total_los_days,
        SUM(patient_satisfaction_score) AS total_satisfaction_points,
        COUNT(patient_satisfaction_score) AS satisfaction_responses_count
    FROM Master_hospital_analytics
    WHERE complication_flag = 1
      AND complication_type IS NOT NULL
      AND complication_type != 'No Complication'
    GROUP BY hospital_code, complication_type
)
-- Step 2: Safe calculation of window percentages and operational averages
SELECT
    hospital_code,
    (SELECT MAX(hospital_name) FROM Master_hospital_analytics m WHERE m.hospital_code = c.hospital_code) AS hospital_name,
    complication_type,
    complication_count,
    
    -- Calculate percentage mix of specific complications within the facility
    ROUND(
        (complication_count::FLOAT / SUM(complication_count) OVER (PARTITION BY hospital_code) * 100)::NUMERIC, 
        2
    ) AS pct_of_complications,
    
    -- Efficiency and Experience impacts
    ROUND((total_los_days::NUMERIC / NULLIF(complication_count, 0)), 1) AS avg_los_with_complication,
    ROUND((total_satisfaction_points::NUMERIC / NULLIF(satisfaction_responses_count, 0)), 2) AS avg_satisfaction_with_complication

FROM complication_base c
ORDER BY hospital_code, complication_count DESC;


-- ============================================================
--OPERATIONAL METRICS: LENGTH OF STAY BY DEPARTMENT
--Identify clinical departments with operational efficiency issues
-- ============================================================

SELECT
    hospital_code,
    MAX(hospital_name) AS hospital_name, -- Included for presentation reporting
    department,
    COUNT(*) AS encounters,
    
    -- Efficiency Metrics
    ROUND(AVG(LOS)::NUMERIC, 1) AS avg_los_days,
    MIN(LOS) AS min_los,
    MAX(LOS) AS max_los,
    
    -- Experience and Quality Metrics
    ROUND(AVG(patient_satisfaction_score)::NUMERIC, 2) AS avg_satisfaction,
    ROUND((AVG(complication_flag) * 100)::NUMERIC, 2) AS complication_rate_pct,
    
    -- Financial Risk per Specialty (Using pre-calculated binary flag)
    ROUND((SUM(is_denied)::FLOAT / COUNT(*) * 100)::NUMERIC, 2) AS denial_rate_pct

FROM Master_hospital_analytics
GROUP BY hospital_code, department
ORDER BY hospital_code, avg_los_days DESC;


-- ============================================================
-- ED (EMERGENCY DEPARTMENT) PERFORMANCE
-- Measure emergency front-door responsiveness and bottlenecks
-- ============================================================

SELECT
    hospital_code,
    MAX(hospital_name) AS hospital_name, -- Included for clear dashboard labeling
    COUNT(*) AS emergency_encounters,
    
    -- Average and Range Bounds
    ROUND(AVG(ed_wait_time_minutes)::NUMERIC, 1) AS avg_ed_wait_minutes,
    MIN(ed_wait_time_minutes) AS min_wait_minutes,
    MAX(ed_wait_time_minutes) AS max_wait_minutes,
    
    -- Percentiles (Explicitly cast to numeric within group to satisfy the parser)
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ed_wait_time_minutes::NUMERIC)::NUMERIC, 1) AS median_wait_minutes,
    ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY ed_wait_time_minutes::NUMERIC)::NUMERIC, 1) AS p90_wait_minutes,
    
    -- Operational Benchmark: % of ED patients waiting more than an hour
    ROUND(
        (COUNT(CASE WHEN ed_wait_time_minutes > 60 THEN 1 END)::FLOAT / COUNT(*) * 100)::NUMERIC, 
        2
    ) AS pct_wait_over_60mins

FROM Master_hospital_analytics
WHERE ed_wait_time_minutes IS NOT NULL
GROUP BY hospital_code
ORDER BY hospital_code;


-- ============================================================
-- PROVIDER PERFORMANCE SCORECARD 
-- Compare individual productivity, financial velocity, and quality metrics per provider
-- ============================================================

WITH provider_metrics_base AS (
    -- Step 1: Pre-aggregate raw caseloads, clinical flags, and financial collections per physician
    SELECT
        hospital_code,
        provider_name,
        COUNT(*) AS total_encounters,
        SUM(mortality_flag) AS total_deaths,
        SUM(complication_flag) AS total_complications,
        SUM(hospital_acquired_infection) AS total_hai,
        COUNT(CASE WHEN LOWER(TRIM(outcome)) = 'readmitted' THEN 1 END) AS total_readmissions,
        SUM(patient_satisfaction_score) AS total_satisfaction_points,
        COUNT(patient_satisfaction_score) AS satisfaction_responses_count,
        SUM(LOS) AS total_los_days,
        SUM(paid_amount) AS total_revenue,
        SUM(is_denied) AS total_denied_claims
    FROM Master_hospital_analytics
    GROUP BY hospital_code, provider_name
)
-- Step 2: Safe calculation of caseload market shares, clinical safety metrics, and financial rates
SELECT
    hospital_code,
    (SELECT MAX(hospital_name) FROM Master_hospital_analytics m WHERE m.hospital_code = p.hospital_code) AS hospital_name,
    provider_name,
    total_encounters,
    
    -- Flawlessly calculate provider caseload share within their specific facility
    ROUND(
        (total_encounters::FLOAT / SUM(total_encounters) OVER (PARTITION BY hospital_code) * 100)::NUMERIC, 
        2
    ) AS share_of_hospital_cases_pct,
    
    -- Clinical Quality and Safety Profiles (Formatted cleanly as dashboard-ready percentages)
    ROUND((total_deaths::FLOAT / NULLIF(total_encounters, 0) * 100)::NUMERIC, 2) AS mortality_rate_pct,
    ROUND((total_complications::FLOAT / NULLIF(total_encounters, 0) * 100)::NUMERIC, 2) AS complication_rate_pct,
    ROUND((total_hai::FLOAT / NULLIF(total_encounters, 0) * 100)::NUMERIC, 2) AS hai_rate_pct,
    ROUND((total_readmissions::FLOAT / NULLIF(total_encounters, 0) * 100)::NUMERIC, 2) AS readmission_rate_pct,
    
    -- Performance and Practice Averages
    ROUND((total_satisfaction_points::NUMERIC / NULLIF(satisfaction_responses_count, 0)), 2) AS avg_patient_satisfaction,
    ROUND((total_los_days::NUMERIC / NULLIF(total_encounters, 0)), 1) AS avg_los_days,
    ROUND((total_revenue::NUMERIC / NULLIF(total_encounters, 0)), 2) AS avg_revenue_per_encounter,
    
    -- Financial Risk Metrics
    ROUND((total_denied_claims::FLOAT / NULLIF(total_encounters, 0) * 100)::NUMERIC, 2) AS denial_rate_pct

FROM provider_metrics_base p
ORDER BY hospital_code, total_encounters DESC;

-- ============================================================
-- PATIENT SATISFACTION DRIVERS
-- Purpose: Understand how severity, admission channel, and specialty correlate with patient perception
-- ============================================================

SELECT
    hospital_code,
    MAX(hospital_name) AS hospital_name, -- Included for clear chart and table grouping
    severity_label,
    admission_type,
    department,
    
    -- Experience, Efficiency, and Quality Metrics
    ROUND(AVG(patient_satisfaction_score)::NUMERIC, 2) AS avg_satisfaction_score,
    ROUND(AVG(LOS)::NUMERIC, 1) AS avg_los_days,
    ROUND((AVG(complication_flag) * 100)::NUMERIC, 2) AS complication_rate_pct,
    
    COUNT(*) AS total_encounters

FROM Master_hospital_analytics
GROUP BY hospital_code, severity_label, admission_type, department
ORDER BY hospital_code, avg_satisfaction_score ASC
LIMIT 50;

-- ============================================================
-- AGE-BAND ANALYSIS 
-- Purpose: Understand patient population demographics and clinical needs per age group
-- ============================================================

WITH age_metrics_base AS (
    -- Step 1: Pre-aggregate raw volumes, length of stay, and financial fields by age segment
    SELECT
        hospital_code,
        age_band,
        COUNT(*) AS encounters,
        SUM(LOS) AS total_los_days,
        SUM(mortality_flag) AS total_deaths,
        SUM(patient_satisfaction_score) AS total_satisfaction_points,
        COUNT(patient_satisfaction_score) AS satisfaction_responses_count,
        SUM(paid_amount) AS total_revenue
    FROM Master_hospital_analytics
    GROUP BY hospital_code, age_band
)
-- Step 2: Safe calculation of window percentages, metrics, and risk rates
SELECT
    hospital_code,
    (SELECT MAX(hospital_name) FROM Master_hospital_analytics m WHERE m.hospital_code = a.hospital_code) AS hospital_name,
    age_band,
    encounters,
    
    -- Flawlessly calculate demographic volume mix percentage within each facility
    ROUND(
        (encounters::FLOAT / SUM(encounters) OVER (PARTITION BY hospital_code) * 100)::NUMERIC, 
        2
    ) AS pct_of_encounters,
    
    -- Operational, Safety, and Financial Averages
    ROUND((total_los_days::NUMERIC / NULLIF(encounters, 0)), 1) AS avg_los,
    ROUND((total_deaths::FLOAT / NULLIF(encounters, 0) * 100)::NUMERIC, 2) AS mortality_rate_pct,
    ROUND((total_satisfaction_points::NUMERIC / NULLIF(satisfaction_responses_count, 0)), 2) AS avg_satisfaction,
    ROUND((total_revenue::NUMERIC / NULLIF(encounters, 0)), 2) AS avg_revenue

FROM age_metrics_base a
ORDER BY hospital_code, age_band;


-- ============================================================
-- QUALITY INCIDENT BREAKDOWN 
-- Purpose: Identify patient safety event categories and operational drag
-- ============================================================

WITH incident_metrics_base AS (
    -- Step 1: Filter out non-incidents and pre-aggregate volume and performance totals
    SELECT
        hospital_code,
        quality_incident,
        COUNT(*) AS incident_count,
        SUM(patient_satisfaction_score) AS total_satisfaction_points,
        COUNT(patient_satisfaction_score) AS satisfaction_responses_count,
        SUM(LOS) AS total_los_days
    FROM Master_hospital_analytics
    WHERE quality_incident IS NOT NULL
      AND quality_incident != 'No Incident'
    GROUP BY hospital_code, quality_incident
)
-- Step 2: Safe calculation of within-hospital incident shares and performance averages
SELECT
    hospital_code,
    (SELECT MAX(hospital_name) FROM Master_hospital_analytics m WHERE m.hospital_code = i.hospital_code) AS hospital_name,
    quality_incident,
    incident_count,
    
    -- Flawlessly calculate the percentage share of each incident type within the facility's total incidents
    ROUND(
        (incident_count::FLOAT / SUM(incident_count) OVER (PARTITION BY hospital_code) * 100)::NUMERIC, 
        2
    ) AS pct_of_total_incidents,
    
    -- Operational and Experience Impacts
    ROUND((total_satisfaction_points::NUMERIC / NULLIF(satisfaction_responses_count, 0)), 2) AS avg_satisfaction_with_incident,
    ROUND((total_los_days::NUMERIC / NULLIF(incident_count, 0)), 1) AS avg_los_with_incident

FROM incident_metrics_base i
ORDER BY hospital_code, incident_count DESC;

-- ============================================================
-- INVESTMENT SCORECARD DATA EXPORT
-- ============================================================

WITH base_kpis AS (
    -- Step 1: Extract overall operational, quality, and baseline financial performance
    SELECT
        hospital_code,
        COUNT(*) AS encounters,
        MAX(total_licensed_beds) AS beds,
        
        -- Financial performance anchors
        ROUND((SUM(paid_amount) / NULLIF(SUM(billed_amount), 0) * 100)::NUMERIC, 2) AS collection_rate_pct,
        ROUND((SUM(is_denied)::FLOAT / COUNT(*) * 100)::NUMERIC, 2) AS denial_rate_pct,
        ROUND(AVG(paid_amount)::NUMERIC, 2) AS avg_rev_per_enc,
        
        -- Clinical Safety indicators
        ROUND((AVG(mortality_flag) * 100)::NUMERIC, 2) AS mortality_rate_pct,
        ROUND((AVG(complication_flag) * 100)::NUMERIC, 2) AS complication_rate_pct,
        ROUND((AVG(hospital_acquired_infection) * 100)::NUMERIC, 2) AS hai_rate_pct,
        ROUND((COUNT(CASE WHEN LOWER(TRIM(outcome)) = 'readmitted' THEN 1 END)::FLOAT / COUNT(*) * 100)::NUMERIC, 2) AS readmission_rate_pct,
        
        -- Operational velocity
        ROUND(AVG(LOS)::NUMERIC, 1) AS avg_los,
        ROUND(AVG(ed_wait_time_minutes)::NUMERIC, 1) AS avg_ed_wait,
        
        -- Utilization (Total encounters scaled across 2 years of data history per bed)
        ROUND((COUNT(*)::FLOAT / NULLIF(MAX(total_licensed_beds), 0) / 2.0)::NUMERIC, 2) AS enc_per_bed_yr,
        ROUND(AVG(patient_satisfaction_score)::NUMERIC, 2) AS avg_satisfaction
    FROM Master_hospital_analytics
    GROUP BY hospital_code
),
yearly_timeline_metrics AS (
    -- Step 2: Establish distinct annual volumes to drive growth ratios safely
    SELECT 
        hospital_code, 
        admission_year,
        SUM(paid_amount) AS annual_revenue, 
        COUNT(*) AS annual_encounters
    FROM Master_hospital_analytics 
    GROUP BY hospital_code, admission_year
),
growth_calculations AS (
    -- Step 3: Pivot and compute clean YoY expansion performance profiles (2022 -> 2023)
    SELECT 
        hospital_code,
        ROUND(
            ((MAX(CASE WHEN admission_year = 2023 THEN annual_revenue END) - MAX(CASE WHEN admission_year = 2022 THEN annual_revenue END))
            / NULLIF(MAX(CASE WHEN admission_year = 2022 THEN annual_revenue END), 0) * 100)::NUMERIC, 
            2
        ) AS revenue_yoy_growth_pct,
        ROUND(
            ((MAX(CASE WHEN admission_year = 2023 THEN annual_encounters END) - MAX(CASE WHEN admission_year = 2022 THEN annual_encounters END))::FLOAT
            / NULLIF(MAX(CASE WHEN admission_year = 2022 THEN annual_encounters END), 0) * 100)::NUMERIC, 
            2
        ) AS encounter_yoy_growth_pct
    FROM yearly_timeline_metrics
    GROUP BY hospital_code
)
-- Step 4: Combine metrics cleanly into the final corporate data deck export
SELECT
    b.hospital_code,
    (SELECT MAX(hospital_name) FROM Master_hospital_analytics m WHERE m.hospital_code = b.hospital_code) AS hospital_name,
    b.encounters,
    b.beds,
    b.collection_rate_pct,
    b.denial_rate_pct,
    b.avg_rev_per_enc,
    g.revenue_yoy_growth_pct,
    g.encounter_yoy_growth_pct,
    b.mortality_rate_pct,
    b.complication_rate_pct,
    b.hai_rate_pct,
    b.readmission_rate_pct,
    b.avg_los,
    b.avg_ed_wait,
    b.enc_per_bed_yr,
    b.avg_satisfaction
FROM base_kpis b
JOIN growth_calculations g ON b.hospital_code = g.hospital_code
ORDER BY b.hospital_code;


