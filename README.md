# Healthcare-investment-analysis: Which Hospital Deserves the Investment?
An independent, data-driven investment analysis for **NorthBridge Health Investment Fund**, evaluating three shortlisted hospitals; Greenfield General Hospital (GGH), Eastpoint Community Hospital (ECH), and Riverside Medical Centre (RMC); to recommend which one should receive a five-year capital investment.

> **Recommendation: Invest in Greenfield General Hospital (GGH)**. Highest weighted composite score (**6.30 / 10**), driven by clinical-quality leadership and genuine, capacity-backed room to scale, with a clearly fixable revenue-cycle gap rather than a structural weakness.

##  Project Overview

NorthBridge Health Investment Fund commissioned an independent analysis to evaluate each hospital's operational performance, financial sustainability, clinical quality, and growth potential before committing capital. As lead analyst, I analyzed 24 months (Jan 2022–Dec 2023) of encounter-level and claims data across all three hospitals and built a structured, weighted investment scorecard to support the final recommendation.

**Central question:** *If you were a member of NorthBridge's investment committee, which hospital would you invest in, and why?*

##  Candidates Evaluated

| Hospital | Code | Facility Type | Licensed Beds | Encounters (2022–23) |
|---|---|---|---|---|
| Greenfield General Hospital | GGH | Secondary Care | 280 | 3,600 |
| Eastpoint Community Hospital | ECH | Secondary Care | 190 | 3,500 |
| Riverside Medical Centre | RMC | Tertiary Care | 480 | 3,800 |

##  Methodology

Each hospital was scored **1–10** on **20 criteria** across **5 weighted investment pillars**. Scores reflect each hospital's relative standing against the other two candidates on the underlying KPI (the strongest performer on a given metric scores highest; not an absolute industry benchmark).

**Weighted Score = Weight × Raw Score**, and the sum of all 20 weighted scores produces each hospital's **Weighted Total Score out of 10**.

| Pillar | Weight | What It Measures |
|---|---|---|
| **Financial Performance** | 22% | Revenue base, collection strength, billing-to-cash leakage |
| **Clinical Quality** | 30% | Mortality, HAI, readmission, complication, recovery, satisfaction |
| **Claims Efficiency** | 18% | Denial rate, denied revenue at risk, claims processing speed |
| **Operational Efficiency** | 18% | ED wait time, encounters per bed/year, average length of stay |
| **Growth & Scalability** | 12% | Revenue/encounter YoY growth, capacity headroom |


##  Weighted Investment Scorecard Results 

| Pillar (Weight) | GGH | ECH | RMC |
|---|---:|---:|---:|
| Financial Performance (22%) | 0.81 | 1.25 | 1.62 |
| Clinical Quality (30%) | 2.57 | 2.10 | 1.34 |
| Claims Efficiency (18%) | 0.79 | 1.07 | 1.41 |
| Operational Efficiency (18%) | 1.32 | 1.26 | 0.78 |
| Growth & Scalability (12%) | 0.81 | 0.41 | 0.78 |
| **WEIGHTED TOTAL SCORE (of 10)** | **6.30** | **6.09** | **5.93** |
| **Rank** | **1** | 2 | 3 |

### Key findings by pillar

- **Financial Performance** — RMC has the strongest revenue base and collection rate; GGH has the smallest revenue base and highest leakage, but strong encounter volume and clinical outcomes point to a collections problem, not a demand problem.
- **Clinical Quality** — GGH leads on every metric: lowest mortality, HAI, readmission, and complication rates, and the highest recovery rate. RMC posts the weakest results in this pillar despite its financial strength. This is the largest-weighted pillar (30%).
- **Claims Efficiency** — RMC's revenue-cycle operation is the most mature (lowest denial rate, least revenue at risk). GGH's high denial rate is the single largest fixable lever for improving its financial position.
- **Operational Efficiency** — GGH has the shortest ED wait time and shortest average length of stay. ECH's high encounters/bed/year looks strong in isolation, but signals near-max capacity — see Growth below.
- **Growth & Scalability (revised)** — ECH's fast revenue growth is capped by near-max bed utilization (9.21 enc/bed/yr); GGH has real headroom to scale (6.43 enc/bed/yr) once its revenue-cycle gap is fixed; RMC's headroom (3.96) reflects underuse, not demand.

##  Risks & Considerations

- **GGH (recommended):** Weakest revenue and denial rate in the field, but addressable via a revenue-cycle-management engagement; smallest current revenue base means a slower absolute payback.
- **ECH:** Balanced, undifferentiated performer; lower risk, but limited upside relative to GGH.
- **RMC:** Strongest financial and claims performance, but the weakest clinical-quality and patient-satisfaction scores; carries regulatory and reputational risk over a 5-year hold.

##  Tools & Tech Stack

| Stage | Tool |
|---|---|
| Data cleaning & KPI aggregation | SQL (PostgreSQL) |
| Investment scorecard | Excel (weighted formulas) |
| Executive dashboard | Power BI |
|Presentation deck | PowerPoint |
| Documentation | PDF |

##  Repository Structure

```
hospital-investment-case/
│
├── data/
│   ├── HospitalA_ECH.csv
│   ├── HospitalB_GGH.csv
│   └── HospitalC_RMC.csv
│
├── sql/
│   └── NORTHBRIDGE CAPSTONE.sql          # table creation, cleaning, data-quality audit,
│                                           # analytical queries, scorecard data export
│
├── powerbi/
│   └── Northbridge investment projecttt.pbix
│
├── excel/
│   └── Northbridge_Hospital_Investment_Scorecard.xlsx   # Cover, Methodology,
│                                                          # Investment Scorecard, Metrics Summary
│
├── presentation/
│   └── Northbridge Investment Presentation Deck.pptx
│
├── report/
│   └── Northbridge Investment Recommendation Report.pdf
│
├── docs/
│   └── Hospital_Investment_Metadata.docx  # data dictionary
│
└── README.md
```

## Data

- **Source:** Two years (2022–2023) of encounter-level and claims data per hospital — patient demographics, admissions/discharges, ED activity, diagnoses/procedures, clinical outcomes, quality/safety indicators, patient satisfaction, payer mix, billing and reimbursement, and claims status/denials.
- **Volume:** ~3,500–3,800 encounters per hospital (~10,900 total).
- **Data dictionary:** see `docs/Hospital_Investment_Metadata.docx`.

##  How to Reproduce

1. Load the three hospital CSVs into PostgreSQL (or your engine of choice) using the table definitions in `sql/NORTHBRIDGE CAPSTONE.sql`.
2. Run the data-cleaning and data-quality-audit queries, then the analytical query blocks (Master KPI Summary, Financial Performance, Clinical Quality, Operational Efficiency, Growth & YoY, Claim Status, Payer Mix, etc.).
3. Run the **Investment Scorecard Data Export** query at the end of the script to produce the per-hospital KPI table used to inform scoring.
4. Open `excel/Northbridge_Hospital_Investment_Scorecard.xlsx` to review or adjust the scorecard — Weight and Score cells are editable inputs; Weighted columns and totals recalculate automatically.
5. Open `powerbi/Northbridge investment projecttt.pbix` for the interactive executive dashboard.

##  Author

**Stella Obase** — *STELLANALYZES*
Data Analyst Intern, Dataverse Africa Healthcare Data Analyst Track (Cohort 4.0)


