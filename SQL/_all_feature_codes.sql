DROP TABLE IF EXISTS #feature_codes_stage;

CREATE TABLE #feature_codes_stage (
    cp_name      NVARCHAR(118) NOT NULL,
    feature_id   NVARCHAR(10) NOT NULL,
    module       NVARCHAR(30),
    vocabulary   VARCHAR(20),
    code         VARCHAR(50) NOT NULL,
    include_descendants BIT NOT NULL,
    gene_symbol  NVARCHAR(10),
    hgnc_id      NVARCHAR(20),
    interpretations NVARCHAR(128)
);

INSERT INTO #feature_codes_stage (cp_name, feature_id, module, vocabulary, code, include_descendants, gene_symbol, hgnc_id, interpretations) VALUES
(N'mondo0000045-congenital-nongoitrous-hypothyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E03.1', 1, NULL, NULL, NULL),
(N'mondo0000045-congenital-nongoitrous-hypothyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'725462002', 1, NULL, NULL, NULL),
(N'mondo0000045-congenital-nongoitrous-hypothyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'1230272009', 1, NULL, NULL, NULL),
(N'mondo0000045-congenital-nongoitrous-hypothyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'1260240000', 1, NULL, NULL, NULL),
(N'mondo0000045-congenital-nongoitrous-hypothyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'1366539009', 1, NULL, NULL, NULL),
(N'mondo0000045-congenital-nongoitrous-hypothyroidism_L1_v1.0', N'f2', N'genetic_finding', N'LOINC', N'53037-8', 0, N'IRS4', N'HGNC:6128', N'Pathogenic [LOINC:LA6668-3]; Likely pathogenic [LOINC:LA26332-9]'),
(N'mondo0000045-congenital-nongoitrous-hypothyroidism_L1_v1.0', N'f3', N'genetic_finding', N'LOINC', N'53037-8', 0, N'TBL1X', N'HGNC:11585', N'Pathogenic [LOINC:LA6668-3]; Likely pathogenic [LOINC:LA26332-9]'),
(N'mondo0000188-glut1-deficiency-syndrome_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E74.810', 1, NULL, NULL, NULL),
(N'mondo0000188-glut1-deficiency-syndrome_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'445252005', 1, NULL, NULL, NULL),
(N'mondo0001029-klippel-feil-syndrome_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'Q76.1', 1, NULL, NULL, NULL),
(N'mondo0001029-klippel-feil-syndrome_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'5601008', 0, NULL, NULL, NULL),
(N'mondo0001029-klippel-feil-syndrome_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'129581007', 1, NULL, NULL, NULL),
(N'mondo0001029-klippel-feil-syndrome_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'205441002', 1, NULL, NULL, NULL),
(N'mondo0001029-klippel-feil-syndrome_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'388981000', 1, NULL, NULL, NULL),
(N'mondo0001029-klippel-feil-syndrome_L1_v1.0', N'f2', N'genetic_finding', N'LOINC', N'53037-8', 0, N'MEOX1', N'HGNC:7013', N'Pathogenic [LOINC:LA6668-3]; Likely pathogenic [LOINC:LA26332-9]'),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'D74', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'D74.0', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'D74.9', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'234397008', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'267550008', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'38959009', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'74912001', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'123768009', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'124184009', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'191387003', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'191389000', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'234395000', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'234396004', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'57020009', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'767497003', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'767498008', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'767499000', 1, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f2', N'diagnostic_test', N'LOINC', N'109634-6', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f2', N'diagnostic_test', N'LOINC', N'32703-1', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f3', N'diagnostic_test', N'LOINC', N'53224-2', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f4', N'diagnostic_test', N'LOINC', N'4606-0', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f5', N'diagnostic_test', N'LOINC', N'4607-8', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f6', N'diagnostic_test', N'LOINC', N'4608-6', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f7', N'diagnostic_test', N'LOINC', N'4609-4', 0, NULL, NULL, NULL),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'f8', N'diagnostic_test', N'LOINC', N'51614-6', 0, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E20', 0, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E20.8', 0, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E20.0', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E20.81', 0, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E20.810', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E20.811', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E20.812', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E20.818', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E20.819', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E20.89', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E20.9', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'237657009', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'36976004', 0, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'711152006', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'725036000', 0, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'75316000', 0, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'1217515007', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'1217517004', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'190456005', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'237654002', 0, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'237655001', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'26267006', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'63981007', 0, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'717893006', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'717895004', 0, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'717897007', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'717898002', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'717903003', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'88760006', 1, NULL, NULL, NULL),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'f2', N'genetic_finding', N'LOINC', N'53037-8', 0, N'PTH', N'HGNC:9606', N'Pathogenic [LOINC:LA6668-3]; Likely pathogenic [LOINC:LA26332-9]'),
(N'mondo0001347-facioscapulohumeral-muscular-dystrophy_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'G71.02', 1, NULL, NULL, NULL),
(N'mondo0001347-facioscapulohumeral-muscular-dystrophy_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'399091004', 1, NULL, NULL, NULL),
(N'mondo0001347-facioscapulohumeral-muscular-dystrophy_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'56096001', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E26.0', 0, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E26.01', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E26.02', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E26.09', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'190507007', 0, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'703231005', 0, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'703233008', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'703234002', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'715868005', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'1074009', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'1351276005', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'13536004', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'237741001', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'237742008', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'237743003', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'257242002', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'258117004', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'69194003', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'703232003', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'703306007', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'768470007', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'778064009', 1, NULL, NULL, NULL),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'789063000', 1, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E76.0', 0, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E76.02', 1, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E76.01', 1, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'E76.03', 1, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'26745009', 1, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'65327002', 1, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'73123008', 1, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'75610003', 0, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'190938004', 1, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'267453008', 1, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f2', N'genetic_finding', N'LOINC', N'53037-8', 0, N'IDUA', N'HGNC:5391', N'Pathogenic [LOINC:LA6668-3]; Likely pathogenic [LOINC:LA26332-9]'),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f3', N'diagnostic_test', N'LOINC', N'1699-8', 0, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f3', N'diagnostic_test', N'LOINC', N'24056-4', 0, NULL, NULL, NULL),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'f3', N'diagnostic_test', N'LOINC', N'24057-2', 0, NULL, NULL, NULL),
(N'mondo0001734-tuberous-sclerosis_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'Q85.1', 1, NULL, NULL, NULL),
(N'mondo0001734-tuberous-sclerosis_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'7199000', 0, NULL, NULL, NULL),
(N'mondo0001734-tuberous-sclerosis_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'157027006', 1, NULL, NULL, NULL),
(N'mondo0001734-tuberous-sclerosis_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'233718008', 1, NULL, NULL, NULL),
(N'mondo0001734-tuberous-sclerosis_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'254243001', 1, NULL, NULL, NULL),
(N'mondo0001734-tuberous-sclerosis_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'36025004', 1, NULL, NULL, NULL),
(N'mondo0001734-tuberous-sclerosis_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'403823001', 1, NULL, NULL, NULL),
(N'mondo0001734-tuberous-sclerosis_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'707433009', 1, NULL, NULL, NULL),
(N'mondo0001901-selective-igg-subclass-deficiency_L1_v1.0', N'f1', N'diagnostic_code', N'ICD10CM', N'D80.3', 1, NULL, NULL, NULL),
(N'mondo0001901-selective-igg-subclass-deficiency_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'123785006', 0, NULL, NULL, NULL),
(N'mondo0001901-selective-igg-subclass-deficiency_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'234546001', 1, NULL, NULL, NULL),
(N'mondo0001901-selective-igg-subclass-deficiency_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'234547005', 1, NULL, NULL, NULL),
(N'mondo0001901-selective-igg-subclass-deficiency_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'234548000', 1, NULL, NULL, NULL),
(N'mondo0001901-selective-igg-subclass-deficiency_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'234549008', 1, NULL, NULL, NULL),
(N'mondo0001901-selective-igg-subclass-deficiency_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'234550008', 1, NULL, NULL, NULL),
(N'mondo0001901-selective-igg-subclass-deficiency_L1_v1.0', N'f1', N'diagnostic_code', N'SNOMED', N'840472009', 1, NULL, NULL, NULL);

CREATE INDEX ix_vocabulary_code ON #feature_codes_stage (vocabulary, code);

DROP TABLE IF EXISTS #feature_codes;

SELECT
    s.cp_name,
    s.feature_id,
    s.module,
    s.vocabulary,
    s.code,
    s.include_descendants,
    s.gene_symbol,
    s.hgnc_id,
    s.interpretations,
    c.concept_id,
    c.concept_name,
    c.domain_id,
    c.concept_class_id,
    c.standard_concept,
    c.invalid_reason,
    cs.concept_id        AS standard_concept_id,
    cs.concept_name      AS standard_concept_name,
    cs.domain_id         AS standard_domain_id,
    CAST(NULL AS BIGINT) AS descendant_of
INTO #feature_codes
FROM #feature_codes_stage AS s
LEFT JOIN omop.concept AS c
       ON c.vocabulary_id = s.vocabulary
      AND c.concept_code  = s.code
LEFT JOIN omop.concept_relationship AS cr
       ON cr.concept_id_1    = c.concept_id
      AND cr.relationship_id = 'Maps to'
      AND cr.invalid_reason IS NULL
LEFT JOIN omop.concept AS cs
       ON cs.concept_id       = cr.concept_id_2
      AND cs.standard_concept = 'S'
      AND cs.invalid_reason IS NULL;

INSERT INTO #feature_codes (cp_name, feature_id, module, vocabulary, code, include_descendants,
                     gene_symbol, hgnc_id, interpretations,
                     concept_id, concept_name, domain_id, concept_class_id, standard_concept, invalid_reason, standard_concept_id, standard_concept_name, standard_domain_id, descendant_of)
SELECT DISTINCT
    f.cp_name, f.feature_id, f.module, f.vocabulary, f.code, f.include_descendants,
    f.gene_symbol, f.hgnc_id, f.interpretations,
    f.concept_id, f.concept_name, f.domain_id, f.concept_class_id,
    f.standard_concept, f.invalid_reason,
    d.concept_id, d.concept_name, d.domain_id,
    a.ancestor_concept_id
FROM #feature_codes AS f
JOIN omop.concept_ancestor AS a
  ON a.ancestor_concept_id   = COALESCE(f.standard_concept_id, f.concept_id)
 AND a.descendant_concept_id <> a.ancestor_concept_id
JOIN omop.concept AS d
  ON d.concept_id       = a.descendant_concept_id
 AND d.standard_concept = 'S'
 AND d.invalid_reason IS NULL
WHERE f.include_descendants = 1
  AND f.descendant_of IS NULL;

CREATE INDEX ix_final_concept ON #feature_codes (concept_id);
CREATE INDEX ix_final_std ON #feature_codes (standard_concept_id);

SELECT cp_name, feature_id, module, vocabulary, code
FROM #feature_codes
WHERE concept_id IS NULL
ORDER BY vocabulary, code;

DROP TABLE IF EXISTS #feature_codes_disjuncts;

CREATE TABLE #feature_codes_disjuncts (
    cp_name      NVARCHAR(118) NOT NULL,
    criterion_id NVARCHAR(10) NOT NULL,
    feature_id   NVARCHAR(10) NOT NULL,
    label        NVARCHAR(112)
);

INSERT INTO #feature_codes_disjuncts (cp_name, criterion_id, feature_id, label) VALUES
(N'mondo0000045-congenital-nongoitrous-hypothyroidism_L1_v1.0', N'd1', N'f1', N'congenital nongoitrous hypothyroidism diagnosis codes'),
(N'mondo0000045-congenital-nongoitrous-hypothyroidism_L1_v1.0', N'd2', N'f2', N'Pathogenic or likely pathogenic IRS4 variant'),
(N'mondo0000045-congenital-nongoitrous-hypothyroidism_L1_v1.0', N'd3', N'f3', N'Pathogenic or likely pathogenic TBL1X variant'),
(N'mondo0000188-glut1-deficiency-syndrome_L1_v1.0', N'd1', N'f1', N'GLUT1 deficiency syndrome diagnosis codes'),
(N'mondo0001029-klippel-feil-syndrome_L1_v1.0', N'd1', N'f1', N'Klippel-Feil syndrome diagnosis codes'),
(N'mondo0001029-klippel-feil-syndrome_L1_v1.0', N'd2', N'f2', N'Pathogenic or likely pathogenic MEOX1 variant'),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'd1', N'f1', N'methemoglobinemia diagnosis codes'),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'd2', N'f2', N'Cytochrome b5 reductase, below the reference range'),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'd3', N'f3', N'Hemoglobin M, positive'),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'd4', N'f4', N'Hemoglobin M-Boston, positive'),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'd5', N'f5', N'Hemoglobin M-Hyde park, positive'),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'd6', N'f6', N'Hemoglobin M-Iwate, positive'),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'd7', N'f7', N'Hemoglobin M-Milwaukee, positive'),
(N'mondo0001117-methemoglobinemia_L1_v1.0', N'd8', N'f8', N'Hemoglobin M/Hemoglobin.total, above the reference range'),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'd1', N'f1', N'hypoparathyroidism diagnosis codes'),
(N'mondo0001220-hypoparathyroidism_L1_v1.0', N'd2', N'f2', N'Pathogenic or likely pathogenic PTH variant'),
(N'mondo0001347-facioscapulohumeral-muscular-dystrophy_L1_v1.0', N'd1', N'f1', N'facioscapulohumeral muscular dystrophy diagnosis codes'),
(N'mondo0001422-primary-aldosteronism_L1_v1.0', N'd1', N'f1', N'primary aldosteronism diagnosis codes'),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'd1', N'f1', N'mucopolysaccharidosis type 1 diagnosis codes'),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'd2', N'f2', N'Pathogenic or likely pathogenic IDUA variant'),
(N'mondo0001586-mucopolysaccharidosis-type-1_L1_v1.0', N'd3', N'f3', N'Alpha-L-iduronidase, below the reference range'),
(N'mondo0001734-tuberous-sclerosis_L1_v1.0', N'd1', N'f1', N'tuberous sclerosis diagnosis codes'),
(N'mondo0001901-selective-igg-subclass-deficiency_L1_v1.0', N'd1', N'f1', N'selective IgG subclass deficiency diagnosis codes');

CREATE INDEX ix_cp_name_feature_id ON #feature_codes_disjuncts (cp_name, feature_id);

DROP TABLE IF EXISTS #feature_codes_concepts;

SELECT DISTINCT
    cp_name,
    feature_id,
    COALESCE(standard_concept_id, concept_id) AS concept_id,
    COALESCE(standard_domain_id, domain_id) AS domain_id
INTO #feature_codes_concepts
FROM #feature_codes
WHERE COALESCE(standard_concept_id, concept_id) IS NOT NULL;

CREATE INDEX ix_concepts ON #feature_codes_concepts (domain_id, concept_id) INCLUDE (cp_name, feature_id);

DROP TABLE IF EXISTS #feature_codes_events;

WITH e AS (
    SELECT c.cp_name, c.feature_id, c.domain_id,
           CAST(t.condition_occurrence_id AS BIGINT) AS event_id, t.person_id
    FROM #feature_codes_concepts AS c
    JOIN omop.condition_occurrence AS t ON t.condition_concept_id = c.concept_id
    WHERE c.domain_id = 'Condition'
    UNION ALL
    SELECT c.cp_name, c.feature_id, c.domain_id,
           CAST(t.measurement_id AS BIGINT) AS event_id, t.person_id
    FROM #feature_codes_concepts AS c
    JOIN omop.measurement AS t ON t.measurement_concept_id = c.concept_id
    WHERE c.domain_id = 'Measurement'
    UNION ALL
    SELECT c.cp_name, c.feature_id, c.domain_id,
           CAST(t.drug_exposure_id AS BIGINT) AS event_id, t.person_id
    FROM #feature_codes_concepts AS c
    JOIN omop.drug_exposure AS t ON t.drug_concept_id = c.concept_id
    WHERE c.domain_id = 'Drug'
    UNION ALL
    SELECT c.cp_name, c.feature_id, c.domain_id,
           CAST(t.procedure_occurrence_id AS BIGINT) AS event_id, t.person_id
    FROM #feature_codes_concepts AS c
    JOIN omop.procedure_occurrence AS t ON t.procedure_concept_id = c.concept_id
    WHERE c.domain_id = 'Procedure'
    UNION ALL
    SELECT c.cp_name, c.feature_id, c.domain_id,
           CAST(t.observation_id AS BIGINT) AS event_id, t.person_id
    FROM #feature_codes_concepts AS c
    JOIN omop.observation AS t ON t.observation_concept_id = c.concept_id
    WHERE c.domain_id = 'Observation'
    UNION ALL
    SELECT c.cp_name, c.feature_id, c.domain_id,
           CAST(t.device_exposure_id AS BIGINT) AS event_id, t.person_id
    FROM #feature_codes_concepts AS c
    JOIN omop.device_exposure AS t ON t.device_concept_id = c.concept_id
    WHERE c.domain_id = 'Device'
    UNION ALL
    SELECT c.cp_name, c.feature_id, c.domain_id,
           CAST(t.visit_occurrence_id AS BIGINT) AS event_id, t.person_id
    FROM #feature_codes_concepts AS c
    JOIN omop.visit_occurrence AS t ON t.visit_concept_id = c.concept_id
    WHERE c.domain_id = 'Visit'
    UNION ALL
    SELECT c.cp_name, c.feature_id, c.domain_id,
           CAST(t.specimen_id AS BIGINT) AS event_id, t.person_id
    FROM #feature_codes_concepts AS c
    JOIN omop.specimen AS t ON t.specimen_concept_id = c.concept_id
    WHERE c.domain_id = 'Specimen'
)
SELECT *
INTO #feature_codes_events
FROM e;

CREATE INDEX ix_events ON #feature_codes_events (cp_name, feature_id) INCLUDE (domain_id, event_id, person_id);

DROP TABLE IF EXISTS #feature_codes_counts;

WITH ev AS (
    SELECT DISTINCT cp_name, domain_id, event_id, person_id
    FROM #feature_codes_events
)
SELECT
    cp_name,
    CAST(CASE WHEN GROUPING(domain_id) = 1 THEN 'All domains' ELSE domain_id END
         AS VARCHAR(20))          AS domain_id,
    COUNT_BIG(*)                  AS n_records,
    COUNT(DISTINCT person_id)     AS n_persons,
    CAST(NULL AS VARCHAR(30))     AS note
INTO #feature_codes_counts
FROM ev
GROUP BY GROUPING SETS ((cp_name, domain_id), (cp_name));

INSERT INTO #feature_codes_counts (cp_name, domain_id, n_records, n_persons, note)
SELECT DISTINCT c.cp_name, c.domain_id, 0, 0,
       CASE WHEN c.domain_id NOT IN ('Condition', 'Measurement', 'Drug', 'Procedure', 'Observation', 'Device', 'Visit', 'Specimen') THEN 'domain not counted' END
FROM #feature_codes_concepts AS c
WHERE NOT EXISTS (SELECT 1 FROM #feature_codes_counts AS f
                  WHERE f.cp_name = c.cp_name AND f.domain_id = c.domain_id);

INSERT INTO #feature_codes_counts (cp_name, domain_id, n_records, n_persons, note)
SELECT DISTINCT c.cp_name, 'All domains', 0, 0, NULL
FROM #feature_codes_concepts AS c
WHERE NOT EXISTS (SELECT 1 FROM #feature_codes_counts AS f
                  WHERE f.cp_name = c.cp_name AND f.domain_id = 'All domains');

SELECT *
FROM #feature_codes_counts
ORDER BY cp_name,
         CASE WHEN domain_id = 'All domains' THEN 1 ELSE 0 END,
         domain_id;

DROP TABLE IF EXISTS #feature_codes_population;

SELECT
    CAST(N'all_persons' AS NVARCHAR(20))  AS population_type,
    COUNT(DISTINCT person_id)        AS n_persons
INTO #feature_codes_population
FROM omop.person
UNION ALL
SELECT N'observation_time', COUNT(DISTINCT person_id)
FROM omop.observation_period
WHERE observation_period_start_date is not null;

DROP TABLE IF EXISTS #feature_codes_feature_counts;

SELECT
    f.cp_name,
    f.feature_id,
    COUNT_BIG(e.event_id)       AS n_records,
    COUNT(DISTINCT e.person_id) AS n_persons
INTO #feature_codes_feature_counts
FROM (SELECT DISTINCT cp_name, feature_id FROM #feature_codes) AS f
LEFT JOIN #feature_codes_events AS e
       ON e.cp_name    = f.cp_name
      AND e.feature_id = f.feature_id
GROUP BY f.cp_name, f.feature_id;

SELECT * FROM #feature_codes_feature_counts ORDER BY cp_name, feature_id;

DROP TABLE IF EXISTS #feature_codes_cohort;

SELECT DISTINCT
    e.person_id,
    d.cp_name,
    d.criterion_id,
    d.feature_id
INTO #feature_codes_cohort
FROM #feature_codes_disjuncts AS d
JOIN #feature_codes_events AS e
  ON e.cp_name    = d.cp_name
 AND e.feature_id = d.feature_id;

CREATE INDEX ix_cohort ON #feature_codes_cohort (cp_name, criterion_id, person_id) INCLUDE (feature_id);

DROP TABLE IF EXISTS #feature_codes_criteria;

WITH crit_events AS (
    SELECT DISTINCT d.cp_name, d.criterion_id, e.domain_id, e.event_id, e.person_id
    FROM #feature_codes_disjuncts AS d
    JOIN #feature_codes_events AS e
      ON e.cp_name    = d.cp_name
     AND e.feature_id = d.feature_id
),
criteria AS (
    SELECT cp_name, criterion_id, MIN(label) AS label
    FROM #feature_codes_disjuncts
    GROUP BY cp_name, criterion_id
),
crit_counts AS (
    SELECT cp_name, criterion_id,
           COUNT_BIG(*) AS n_records, COUNT(DISTINCT person_id) AS n_persons
    FROM crit_events
    GROUP BY cp_name, criterion_id
),
file_events AS (
    SELECT DISTINCT cp_name, domain_id, event_id, person_id
    FROM #feature_codes_events
),
summary AS (
    SELECT cp_name, COUNT_BIG(*) AS n_records, COUNT(DISTINCT person_id) AS n_persons
    FROM file_events
    GROUP BY cp_name
),
cps AS (
    SELECT DISTINCT cp_name FROM #feature_codes
)
SELECT
    CAST('summary' AS VARCHAR(10))  AS row_type,
    p.cp_name,
    CAST(NULL AS NVARCHAR(1))       AS criterion_id,
    CAST(NULL AS NVARCHAR(1))       AS label,
    COALESCE(s.n_persons, 0)        AS n_persons,
    COALESCE(s.n_records, 0)        AS n_records
INTO #feature_codes_criteria
FROM cps AS p
LEFT JOIN summary AS s ON s.cp_name = p.cp_name
UNION ALL
SELECT
    'count',
    c.cp_name,
    c.criterion_id,
    c.label,
    COALESCE(k.n_persons, 0),
    COALESCE(k.n_records, 0)
FROM criteria AS c
LEFT JOIN crit_counts AS k
       ON k.cp_name      = c.cp_name
      AND k.criterion_id = c.criterion_id;

SELECT
    NULL                          AS SITE_CODE,
    RIGHT(c.cp_name, 7)           AS RESULT_SPEC_VERSION,
    NULL                          AS GENERATED_AT,
    c.cp_name                     AS CP_NAME,
    NULL                          AS RUN_DATE,
    NULL                          AS DATA_SNAPSHOT_DATE,
    c.row_type                    AS ROW_TYPE,
    c.label                       AS LABEL,
    COALESCE(c.criterion_id, N'') AS CRITERION_ID,
    p.n_persons                   AS POPULATION_N,
    p.population_type             AS POPULATION_BASIS,
    NULL                          AS POPULATION_BASIS_NOTE,
    c.n_persons                   AS COUNT_VALUE,
    NULL                          AS COUNT_STATUS
FROM #feature_codes_criteria AS c
LEFT JOIN #feature_codes_population AS p
       ON c.row_type = 'summary'
ORDER BY c.cp_name,
         CASE WHEN c.row_type = 'summary' THEN 0 ELSE 1 END,
         c.criterion_id,
         p.population_type DESC;
