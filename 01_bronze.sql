BankMarketingRaw:
LOAD
    "age",
    job,
    marital,
    education,
    "default",
    balance,
    housing,
    loan,
    contact,
    "day",
    "month",
    duration,
    campaign,
    pdays,
    "previous",
    poutcome,
    deposit
FROM [lib://DataFiles/bank.csv]
(txt, codepage is 28591, embedded labels, delimiter is ',', msq);

STORE BankMarketingRaw
INTO [lib://DataFiles/bronze_bank_marketing.qvd] (qvd);

DROP TABLE BankMarketingRaw;