BankMarketingRaw:
LOAD *
FROM [lib://DataFiles/bronze_bank_marketing.qvd]
(qvd);

BankMarketingClean:
NoConcatenate
LOAD
    age,
    Lower(Trim(job)) AS job,
    Lower(Trim(marital)) AS marital,
    Lower(Trim(education)) AS education,
    Lower(Trim([default])) AS [default],
    balance,
    Lower(Trim(housing)) AS housing,
    Lower(Trim(loan)) AS loan,
    Lower(Trim(contact)) AS contact,
    [day],
    Lower(Trim([month])) AS [month],
    duration,
    campaign,
    pdays,
    previous,
    Lower(Trim(poutcome)) AS poutcome,
    Lower(Trim(deposit)) AS deposit
RESIDENT BankMarketingRaw;

BankMarketingSilver:
NoConcatenate
LOAD
    *,

    // FAIXA ETARIA
    If(age < 30, '01 | 18-29',
    If(age < 40, '02 | 30-39',
    If(age < 50, '03 | 40-49',
    If(age < 60, '04 | 50-59',
                 '05 | 60+')))) AS age_group,

    // FAIXA DE SALDO BANCARIO
    If(balance < 0, '01 | Negativo',
    If(balance = 0, '02 | Zero',
    If(balance < 1000, '03 | Baixo',
    If(balance < 5000, '04 | Medio',
                       '05 | Alto')))) AS balance_group,

    // DURACAO DO CONTATO (SEGUNDOS)
    If(duration <= 120, '01 | Ate 2 min',
    If(duration <= 300, '02 | 2-5 min',
    If(duration <= 600, '03 | 5-10 min',
                        '04 | Mais de 10 min'))) AS duration_group,

    // QUANTIDADE DE CONTATOS NA CAMPANHA
    If(campaign = 1, '01 | 1 contato',
    If(campaign <= 3, '02 | 2-3 contatos',
    If(campaign <= 6, '03 | 4-6 contatos',
                      '04 | 7+ contatos'))) AS campaign_group,

    // CONTATOS EM CAMPANHAS ANTERIORES
    If(previous = 0, '01 | Nenhum',
    If(previous = 1, '02 | 1 contato',
    If(previous <= 3, '03 | 2-3 contatos',
                      '04 | 4+ contatos'))) AS previous_group,

    // TEMPO DESDE O CONTATO ANTERIOR
    If(pdays = -1, '01 | Nunca contatado',
    If(pdays <= 30, '02 | Ate 30 dias',
    If(pdays <= 180, '03 | 31-180 dias',
                     '04 | Mais de 180 dias'))) AS recency_group

RESIDENT BankMarketingClean
WHERE
    age >= 18
    AND age <= 100
    AND campaign >= 1
    AND duration >= 0
    AND previous >= 0
    AND pdays >= -1
    AND [day] >= 1
    AND [day] <= 31
    AND Match(deposit, 'yes', 'no');



STORE BankMarketingSilver
INTO [lib://DataFiles/silver_bank_marketing.qvd]
(qvd);


LET vTotal = NoOfRows('BankMarketingRaw');
LET vSilver = NoOfRows('BankMarketingSilver');
LET vRejected = $(vTotal) - $(vSilver);

TRACE Total de registros: $(vTotal);
TRACE Registros validos: $(vSilver);
TRACE Registros descartados: $(vRejected);


DROP TABLE BankMarketingRaw;
DROP TABLE BankMarketingClean;
DROP TABLE BankMarketingSilver;