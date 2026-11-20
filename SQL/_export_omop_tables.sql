-- Placeholders: {schema} and {cohort_table} are replaced before running.

-- table: person
SELECT t.person_id, t.gender_concept_id,
       ISNULL(t.year_of_birth, DATEPART(year, t.birth_datetime)) AS year_of_birth,
       ISNULL(t.month_of_birth, DATEPART(month, t.birth_datetime)) AS month_of_birth,
	   ISNULL(t.day_of_birth, DATEPART(day, t.birth_datetime)) AS day_of_birth, t.birth_datetime,
       t.race_concept_id, t.ethnicity_concept_id, t.location_id, t.provider_id,
       t.care_site_id, person_source_value, t.gender_source_value, t.gender_source_concept_id, t.race_source_value, t.race_source_concept_id,
       t.ethnicity_source_value, t.ethnicity_source_concept_id
FROM {schema}.person t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: observation_period
SELECT t.observation_period_id, t.person_id,
       CAST(t.observation_period_start_date AS datetime) AS observation_period_start_date,
       CAST(t.observation_period_end_date AS datetime) AS observation_period_end_date,
       t.period_type_concept_id
FROM {schema}.observation_period t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: visit_occurrence
SELECT t.visit_occurrence_id, t.person_id, t.visit_concept_id,
       CAST(t.visit_start_date AS datetime) AS visit_start_date,
       CAST(t.visit_start_datetime AS datetime) AS visit_start_datetime,
       CAST(t.visit_end_date AS datetime) AS visit_end_date,
       CAST(t.visit_end_datetime AS datetime) AS visit_end_datetime,
       t.visit_type_concept_id, t.provider_id, t.care_site_id,
       t.visit_source_value, t.visit_source_concept_id,
       t.admitted_from_concept_id, t.admitted_from_source_value,
       t.discharged_to_concept_id, t.discharged_to_source_value,
       t.preceding_visit_occurrence_id
FROM {schema}.visit_occurrence t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: visit_detail
SELECT t.visit_detail_id, t.person_id, t.visit_detail_concept_id,
       CAST(t.visit_detail_start_date AS datetime) AS visit_detail_start_date,
       CAST(t.visit_detail_start_datetime AS datetime) AS visit_detail_start_datetime,
       CAST(t.visit_detail_end_date AS datetime) AS visit_detail_end_date,
       CAST(t.visit_detail_end_datetime AS datetime) AS visit_detail_end_datetime,
       t.visit_detail_type_concept_id, t.provider_id, t.care_site_id,
       t.visit_detail_source_value, t.visit_detail_source_concept_id,
       t.admitted_from_concept_id, t.admitted_from_source_value,
       t.discharged_to_concept_id, t.discharged_to_source_value,
       t.preceding_visit_detail_id, t.parent_visit_detail_id, t.visit_occurrence_id
FROM {schema}.visit_detail t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: condition_occurrence
SELECT t.condition_occurrence_id, t.person_id, t.condition_concept_id,
       CAST(t.condition_start_date AS datetime) AS condition_start_date,
       CAST(t.condition_start_datetime AS datetime) AS condition_start_datetime,
       CAST(t.condition_end_date AS datetime) AS condition_end_date,
       CAST(t.condition_end_datetime AS datetime) AS condition_end_datetime,
       t.condition_type_concept_id, t.condition_status_concept_id,
       stop_reason, t.provider_id, t.visit_occurrence_id, visit_detail_id,
       t.condition_source_value, t.condition_source_concept_id,
       condition_status_source_value
FROM {schema}.condition_occurrence t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: drug_exposure
SELECT t.drug_exposure_id, t.person_id, t.drug_concept_id,
       CAST(t.drug_exposure_start_date AS datetime) AS drug_exposure_start_date,
       CAST(t.drug_exposure_start_datetime AS datetime) AS drug_exposure_start_datetime,
       CAST(t.drug_exposure_end_date AS datetime) AS drug_exposure_end_date,
       CAST(t.drug_exposure_end_datetime AS datetime) AS drug_exposure_end_datetime,
	   CAST(t.verbatim_end_date AS date) AS verbatim_end_date,
       t.drug_type_concept_id, NULL AS stop_reason, t.refills, t.quantity,
       t.days_supply, sig, t.route_concept_id, t.lot_number,
       t.provider_id, t.visit_occurrence_id, visit_detail_id,
       t.drug_source_value, t.drug_source_concept_id, t.route_source_value,
       t.dose_unit_source_value
FROM {schema}.drug_exposure t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: device_exposure
SELECT t.device_exposure_id, t.person_id, t.device_concept_id,
       CAST(t.device_exposure_start_date AS datetime) AS device_exposure_start_date,
       CAST(t.device_exposure_start_datetime AS datetime) AS device_exposure_start_datetime,
       CAST(t.device_exposure_end_date AS datetime) AS device_exposure_end_date,
       CAST(t.device_exposure_end_datetime AS datetime) AS device_exposure_end_datetime,
       t.device_type_concept_id, unique_device_id,
       production_id, t.quantity,
       t.provider_id, t.visit_occurrence_id, visit_detail_id,
       t.device_source_value, t.device_source_concept_id,
       t.unit_concept_id, unit_source_value,
       t.unit_source_concept_id
FROM {schema}.device_exposure t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: procedure_occurrence
SELECT t.procedure_occurrence_id, t.person_id, t.procedure_concept_id,
       CAST(t.procedure_date AS datetime) AS procedure_date,
       CAST(t.procedure_datetime AS datetime) AS procedure_datetime,
       CAST(t.procedure_end_date AS datetime) AS procedure_end_date,
       CAST(t.procedure_end_datetime AS datetime) AS procedure_end_datetime,
       t.procedure_type_concept_id, t.modifier_concept_id, t.quantity,
       t.provider_id, t.visit_occurrence_id, visit_detail_id,
       t.procedure_source_value, t.procedure_source_concept_id,
       modifier_source_value
FROM {schema}.procedure_occurrence t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: measurement
SELECT t.measurement_id, t.person_id, t.measurement_concept_id,
       CAST(t.measurement_date AS datetime) AS measurement_date,
       CAST(t.measurement_datetime AS datetime) AS measurement_datetime,
       measurement_time, t.measurement_type_concept_id,
       t.operator_concept_id, t.value_as_number, t.value_as_concept_id,
       t.unit_concept_id, t.range_low, t.range_high, t.provider_id,
       t.visit_occurrence_id, visit_detail_id,
       t.measurement_source_value, t.measurement_source_concept_id,
       unit_source_value, t.unit_source_concept_id,
       value_source_value, t.measurement_event_id,
       t.meas_event_field_concept_id
FROM {schema}.measurement t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: observation
SELECT t.observation_id, t.person_id, t.observation_concept_id,
       CAST(t.observation_date AS datetime) AS observation_date,
       CAST(t.observation_datetime AS datetime) AS observation_datetime,
       t.observation_type_concept_id, t.value_as_number, t.value_as_string,
       t.value_as_concept_id, t.qualifier_concept_id, t.unit_concept_id,
       t.provider_id, t.visit_occurrence_id, visit_detail_id,
       t.observation_source_value, t.observation_source_concept_id,
       unit_source_value, qualifier_source_value,
       value_source_value, t.observation_event_id,
       t.obs_event_field_concept_id
FROM {schema}.observation t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: death
SELECT t.person_id,
       CAST(t.death_date AS datetime) AS death_date,
       CAST(t.death_datetime AS datetime) AS death_datetime,
       t.death_type_concept_id, t.cause_concept_id,
       NULL AS cause_source_value, t.cause_source_concept_id
FROM {schema}.death t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: drug_era
SELECT t.drug_era_id, t.person_id, t.drug_concept_id,
       CAST(t.drug_era_start_date AS datetime) AS drug_era_start_date,
       CAST(t.drug_era_end_date AS datetime) AS drug_era_end_date,
       t.drug_exposure_count, t.gap_days
FROM {schema}.drug_era t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: condition_era
SELECT t.condition_era_id, t.person_id, t.condition_concept_id,
       CAST(t.condition_era_start_date AS datetime) AS condition_era_start_date,
       CAST(t.condition_era_end_date AS datetime) AS condition_era_end_date,
       t.condition_occurrence_count
FROM {schema}.condition_era t
JOIN {cohort_table} c ON t.person_id = c.person_id;

-- table: location
SELECT t.location_id,
       NULL AS address_1, 
       NULL AS address_2, 
       t.city, t.state, t.zip, t.county, NULL AS location_source_value,
       t.country_concept_id, country_source_value,
       NULL AS latitude,  
       NULL AS longitude  
FROM {schema}.location t
JOIN (
        SELECT DISTINCT p.location_id
        FROM {schema}.person p
        JOIN {cohort_table} c
          ON p.person_id = c.person_id
      ) a
  ON t.location_id = a.location_id;

-- table: care_site
SELECT t.care_site_id, t.care_site_name, t.place_of_service_concept_id,
       location_id, care_site_source_value,
       place_of_service_source_value
FROM {schema}.care_site t
JOIN (
        SELECT DISTINCT vo.care_site_id
        FROM {schema}.visit_occurrence vo
        JOIN {cohort_table} c
          ON vo.person_id = c.person_id
		  
		UNION
		 
		SELECT DISTINCT vd.care_site_id
        FROM {schema}.visit_detail vd
        JOIN {cohort_table} c
          ON vd.person_id = c.person_id
      ) a
  ON t.care_site_id = a.care_site_id;

-- table: provider 
SELECT t.provider_id,
       NULL AS provider_name, 
       NULL AS npi,           
       NULL AS dea,           
       t.specialty_concept_id, t.care_site_id, year_of_birth,
       t.gender_concept_id,
       provider_source_value, 
       t.specialty_source_value, t.specialty_source_concept_id,
       t.gender_source_value, t.gender_source_concept_id
FROM {schema}.provider t
JOIN (
       SELECT DISTINCT p.provider_id
       FROM {schema}.person p
       JOIN {cohort_table} c
         ON p.person_id = c.person_id
	   UNION
	   SELECT DISTINCT vo.provider_id
       FROM {schema}.visit_occurrence vo
       JOIN {cohort_table} c
         ON vo.person_id = c.person_id
	   UNION
       SELECT DISTINCT vd.provider_id
       FROM {schema}.visit_detail vd
       JOIN {cohort_table} c
         ON vd.person_id = c.person_id
       UNION
       SELECT DISTINCT de.provider_id
       FROM {schema}.drug_exposure de
       JOIN {cohort_table} c
         ON de.person_id = c.person_id
       UNION
       SELECT DISTINCT m.provider_id
       FROM {schema}.measurement m
       JOIN {cohort_table} c
         ON m.person_id = c.person_id
       UNION
       SELECT DISTINCT po.provider_id
       FROM {schema}.procedure_occurrence po
       JOIN {cohort_table} c
         ON po.person_id = c.person_id
       UNION
       SELECT DISTINCT o.provider_id
       FROM {schema}.observation o
       JOIN {cohort_table} c
         ON o.person_id = c.person_id
	   UNION
       SELECT DISTINCT co.provider_id
       FROM {schema}.condition_occurrence co
       JOIN {cohort_table} c
         ON co.person_id = c.person_id
     ) a
  ON t.provider_id = a.provider_id;
  
-- table: cohort
SELECT DISTINCT * FROM {cohort_table} c
