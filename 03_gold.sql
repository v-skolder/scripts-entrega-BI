
BankMarketingSilver:
LOAD *
FROM [lib://DataFiles/silver_bank_marketing.qvd]
(qvd);

GoldKPIs:
LOAD
    Count(1) AS total_contacts,

    Sum(If(deposit = 'yes', 1, 0))
        AS total_conversions,

    Sum(If(deposit = 'no', 1, 0))
        AS total_rejections,

    Num(
        Sum(If(deposit = 'yes', 1, 0)) / Count(1),
        '0.00%'
    ) AS conversion_rate,

    Round(Avg(balance), 0.01)
        AS average_balance,

    Round(Avg(duration), 0.01)
        AS average_duration_seconds,

    Round(Avg(campaign), 0.01)
        AS average_campaign_contacts,

    Round(Avg(age), 0.01)
        AS average_age

RESIDENT BankMarketingSilver;

STORE GoldKPIs
INTO [lib://DataFiles/gold_kpis.qvd] (qvd);

DROP TABLE GoldKPIs;

GoldAge:
LOAD
    age_group,

    Count(1) AS total_contacts,

    Sum(If(deposit = 'yes', 1, 0))
        AS total_conversions,

    Num(
        Sum(If(deposit = 'yes', 1, 0)) / Count(1),
        '0.00%'
    ) AS conversion_rate,

    Round(Avg(balance), 2)
        AS average_balance

RESIDENT BankMarketingSilver
GROUP BY age_group;

STORE GoldAge
INTO [lib://DataFiles/gold_age.qvd] (qvd);

DROP TABLE GoldAge;

GoldJob:
LOAD
    job,

    Count(1) AS total_contacts,

    Sum(If(deposit = 'yes', 1, 0))
        AS total_conversions,

    Num(
        Sum(If(deposit = 'yes', 1, 0)) / Count(1),
        '0.00%'
    ) AS conversion_rate,

    Round(Avg(balance), 2)
        AS average_balance

RESIDENT BankMarketingSilver
GROUP BY job;

STORE GoldJob
INTO [lib://DataFiles/gold_job.qvd] (qvd);

DROP TABLE GoldJob;

GoldEducation:
LOAD
    education,

    Count(1) AS total_contacts,

    Sum(If(deposit = 'yes', 1, 0))
        AS total_conversions,

    Num(
        Sum(If(deposit = 'yes', 1, 0)) / Count(1),
        '0.00%'
    ) AS conversion_rate

RESIDENT BankMarketingSilver
GROUP BY education;

STORE GoldEducation
INTO [lib://DataFiles/gold_education.qvd] (qvd);

DROP TABLE GoldEducation;

GoldBalance:
LOAD
    balance_group,

    Count(1) AS total_contacts,

    Sum(If(deposit = 'yes', 1, 0))
        AS total_conversions,

    Num(
        Sum(If(deposit = 'yes', 1, 0)) / Count(1),
        '0.00%'
    ) AS conversion_rate,

    Round(Avg(balance), 2)
        AS average_balance

RESIDENT BankMarketingSilver
GROUP BY balance_group;

STORE GoldBalance
INTO [lib://DataFiles/gold_balance.qvd] (qvd);

DROP TABLE GoldBalance;

GoldCampaign:
LOAD
    campaign_group,

    Count(1) AS total_contacts,

    Sum(If(deposit = 'yes', 1, 0))
        AS total_conversions,

    Num(
        Sum(If(deposit = 'yes', 1, 0)) / Count(1),
        '0.00%'
    ) AS conversion_rate,

    Round(Avg(campaign), 2)
        AS average_campaign_contacts

RESIDENT BankMarketingSilver
GROUP BY campaign_group;

STORE GoldCampaign
INTO [lib://DataFiles/gold_campaign.qvd] (qvd);

DROP TABLE GoldCampaign;

GoldContact:
LOAD
    contact,

    Count(1) AS total_contacts,

    Sum(If(deposit = 'yes', 1, 0))
        AS total_conversions,

    Num(
        Sum(If(deposit = 'yes', 1, 0)) / Count(1),
        '0.00%'
    ) AS conversion_rate,

    Round(Avg(duration), 2)
        AS average_duration_seconds

RESIDENT BankMarketingSilver
GROUP BY contact;

STORE GoldContact
INTO [lib://DataFiles/gold_contact.qvd] (qvd);

DROP TABLE GoldContact;

GoldMonth:
LOAD
    [month],

    Count(1) AS total_contacts,

    Sum(If(deposit = 'yes', 1, 0))
        AS total_conversions,

    Num(
        Sum(If(deposit = 'yes', 1, 0)) / Count(1),
        '0.00%'
    ) AS conversion_rate

RESIDENT BankMarketingSilver
GROUP BY [month];

STORE GoldMonth
INTO [lib://DataFiles/gold_month.qvd] (qvd);

DROP TABLE GoldMonth;

LET vTotal = NoOfRows('BankMarketingSilver');

TRACE ========================================;
TRACE GOLD - BANK MARKETING;
TRACE Registros Silver processados: $(vTotal);
TRACE QVDs analiticos gerados: 8;
TRACE ========================================;

DROP TABLE BankMarketingSilver;