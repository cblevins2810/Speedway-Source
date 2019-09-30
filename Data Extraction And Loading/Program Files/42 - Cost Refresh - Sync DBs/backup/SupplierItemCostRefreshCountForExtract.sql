SET NOCOUNT ON

DECLARE @supplier TABLE (supplier_id INT, name nvarchar(128))
DECLARE @business_unit TABLE (business_unit_id INT)

INSERT @supplier (supplier_id, name)
SELECT DISTINCT s.supplier_id, s.name
FROM   supplier AS s
WHERE xref_code IN (
'FRITO',
'REITER',
'SIZZ',
'DEBBIE',
'SUPER',
'BREAD',
'STORE',
'PEPSIIN',
'COKEIND',
'ROSES',
'EBYAUROR',
'PEPSICIN',
'PEPSICOL',
'COLUDIST',
'ROBNDIST',
'COKECLEV',
'PEPSICLE',
'NICKCLEV',
'WINEDIST',
'RLLIPTON',
'GRIPDAYT',
'TOM',
'PEPSIMUN',
'KOZMILLR',
'BUDCHIC',
'ROMANO',
'PEPSISPR',
'PEPSMICH',
'SCHAEFER',
'MIKESELL',
'COKEELYR',
'INTRASTA',
'PAULSON',
'JUDGE',
'BEERCO',
'GOLDEN',
'PEPSFIND',
'TOMBSTON',
'PEPSFTWA',
'PEPSAKRN',
'DUNKINDO',
'MONARCH2',
'AMERCOMP',
'RUMPKEE',
'PEPSHAML',
'DICKERSN',
'MILLROHI',
'TERRENCE',
'DUTCHOVN',
'TREUHOUS',
'PEPSTOLE',
'PEPSNEWR',
'SCHENKEL',
'SOUTHLAK',
'COKEMANS',
'MANSFIEL',
'ESBERBEV',
'SUBWAY',
'UNIVERSA',
'YETTERS',
'RMAP',
'STANLEY',
'NICKMERR',
'COKEKOKO',
'PAINEENT',
'SANFILIP',
'SCHWEBLS',
'PEPSMANS',
'PEPSCIN2',
'AALCOCAS',
'HAYES',
'BEERCAPI',
'TRICNTY',
'OHIOWINE',
'COKEYOUN',
'CHUCKS',
'DEANDIST',
'HERRCHIP',
'PEPSCHIL',
'COKECHIL',
'CLASBRAN',
'DONUTREA',
'PEPSLIMA',
'NORSKE',
'CALUMETT',
'PEPSCANT',
'HOMEBEVG',
'ZSDIST',
'SYFRTFD',
'MAPLECIY',
'RALPH',
'CITYBEVE',
'TACOBELL',
'LUDWIG',
'COKEPLYM',
'PUREBEV',
'PFS',
'BROWNCO',
'PEPSDOVE',
'HOLSMETZ',
'CITYBEVR',
'EUBLID',
'SCHAMBER',
'CJWDIST',
'MSDIST',
'GENBEVG',
'LEEBEVG',
'HOLSM',
'PEPSITER',
'DANHENRY',
'GRDNFOOD',
'DMAWOOD',
'ELGINBEV',
'WHEELING',
'H.DENNT2',
'PEPSLOUI',
'WNDRLND',
'WIEMUTH',
'EXLUSIVE',
'HSLAROSE',
'BEVERAGE',
'PEPSSOUT',
'HSLRSUMM',
'HELLERS',
'DELMAR',
'MERVENE',
'ALEEIGHT',
'PEPSLEXI',
'MATESICH',
'PEPSBLOO',
'BARTHMEW',
'PEPSRIP',
'SWEETSTP',
'FOWLER',
'METZCRDT',
'IMPERBEV',
'SYSCOCSH',
'RLLIPELE',
'CNTRLDST',
'NTHVRNBV',
'HURNDIST',
'PREMBVG',
'SYSCOCIN',
'HRIZNGAS',
'DUNKDON',
'DOYLEDIS',
'WALTCRAW',
'TYLRSLSC',
'NWODISTR',
'NRTHCSTD',
'SOUBAKEC',
'GOBRSBAK',
'JOHNPSUL',
'BESTBEER',
'PWPWDIST',
'LANGICCO',
'COKEELIZ',
'PEPSELIZ',
'COKEMDLB',
'PEPSCRBN',
'SUPRBEVG',
'COLOTENN',
'CHASELIG',
'ANHSRLOU',
'UNTDBVIN',
'WESTSDE2',
'JPFOODSV',
'BLUERIBB',
'SUNRSDNT',
'GRIPPOFD',
'UNIVEMAP',
'SWEETDNT',
'PEPSCLMB',
'SCOTTGRS',
'PEPSSEYM',
'CKMICH2',
'CKGRNDMI',
'COKETRAV',
'CKVANMI',
'PEPSISAG',
'PEPSGRND',
'PEPSKALA',
'PEPSLANG',
'PEPSPONT',
'PEPSSTJO',
'PEPSIMIL',
'PEPSIPET',
'PEPSIHUR',
'PEPSTRAV',
'PEPSCOLD',
'PEPSIDET',
'COXSON',
'DANIELJB',
'MILLBEV',
'ROSECONN',
'BELOITBV',
'SCHWEITZ',
'KYEAGLE',
'PEPSISP2',
'KLZOODST',
'PEPSMADI',
'RMBAKERY',
'GLACERLQ',
'BUDMICH',
'BAKERSCH',
'STHWSTBR',
'CORBIN',
'PEPSIBIG',
'DUTCHDNT',
'CKWESTKY',
'HEINERS2',
'SOZACHRG',
'DONUTMAN',
'JMULLAKY',
'BAITPLCE',
'COKEFLNT',
'JUICESUN',
'NATUREBE',
'NIKBREAD',
'POSTOFFC',
'GRIFFENB',
'KENTIANA',
'IHSDSTR',
'SYSCOCLV',
'NEPTUNE',
'HAMANBRO',
'ALLIANTM',
'GREBES',
'JERRYDIS',
'MINGUA',
'COKEHNTG',
'COKELGAN',
'PEPSIBLG',
'PEPSICBS',
'PEPSILBN',
'PEPSICMD',
'PEPSIPNT',
'PEPSIPKV',
'PEPSIPSH',
'CKHNTNGT',
'CKLOUISA',
'PEPSIWV',
'COKEHTN',
'SHEELEY',
'SOUTHES',
'BRYANT',
'GOTTAGO',
'PRAXAIR',
'RIVERCIT',
'SNYDER',
'CONNS',
'COKCHAR',
'PEPSNITR',
'ATOMIC',
'BROUGHT',
'CENTRLDS',
'WSBAIT',
'DONUTDAY',
'SYSCOMN',
'FRANKBR',
'RYKO',
'PCTREATS',
'QUICKBT',
'NORTHCEN',
'GENBEV2',
'SMITHBRO',
'SPRIGGS',
'MAYFLWR',
'PRMBRAND',
'MISTERB',
'NATWIN2',
'PEPSICOR',
'PEPSWEST',
'CKDETROT',
'MMDIST',
'BLUELINE',
'LETCHER',
'FOXHENRY',
'MRSPORTS',
'FONTANA',
'ORIGINAL',
'ALPENA',
'GRIFDIST',
'FLORALBV',
'PIAZZ',
'SMITHEA',
'OILDIST',
'BOTTOMLN',
'PREPAID',
'WISCNDST',
'COKECLK2',
'PEPSINT2',
'PEPSCHI3',
'PEPSNIT2',
'PEPSNIT3',
'PEPSINW2',
'MAYSHED',
'GEMBEV',
'GENBEE',
'GENOCON',
'POTTERS',
'FAYGOBVG',
'MARTYS',
'FRESHFLW',
'PRISINGS',
'EBYSMOKE',
'KRETEK',
'SHELTONS',
'TRIMART',
'STEVES',
'PRAIRLAK',
'MAINLINE',
'NATIONWD',
'CLASALB',
'EAGLHUNT',
'EAGLASHL',
'CHASFRNK',
'PERRY',
'GURNDON',
'PEPSGREE',
'COKEBERK',
'COKECLKS',
'COKEPRKB',
'PEPSIPRC',
'STORESFL',
'IDAS',
'REINHART',
'HARLAN',
'HAWKS',
'BEVDIST',
'STATEDIS',
'ALLIANTC',
'VALYDIST',
'GENWINE',
'NTLWINE',
'WESTMI',
'GOODTIME',
'MAINBEV',
'SILVERFM',
'ATLASBEV',
'SOMERICE',
'BLUEHERO',
'INCOMM',
'IRONCTY',
'TRUELOVE',
'CPTLBVG',
'HOMEBAKE',
'SNOUFFER',
'GRNDRPD',
'TRISTATE',
'STEUBEN',
'HEALTHBD',
'DIXIWEST',
'ABRUZZ',
'MCCANN',
'WINEBVG',
'USFOOD3',
'DONSBAIT',
'TONYFISH',
'ROBINSON',
'TRISLER',
'DUNKINMD',
'MUXIE',
'MTNEAGLE',
'CORLEY',
'SYSCOVIR',
'PRODUCE',
'ELKINS',
'RANDOLPH',
'MENSORE',
'ZINK',
'GRNTIMP',
'MERCERWH',
'DAN DEE',
'DUTCHMD',
'STANDNT',
'GRNDVILL',
'KAYDIST',
'PALERMOS',
'ELREY',
'H.DENNKY',
'HINKLES',
'LOMBARBI',
'GREATLAK',
'LANCE',
'HWINECIN',
'OVWINECN',
'HBERGCOL',
'HBERGCLE',
'HBERGTOL',
'SOMERSET',
'VENNYS',
'OHCITRUS',
'TRIJUICE',
'BUCKSDNT',
'RLLIPASH',
'HBEERCIN',
'HBEERDTN',
'TRIDIST2',
'PETERSON',
'GREATAM',
'FLOWBAKE',
'GLOBEJO',
'VALYFAIR',
'LOYALTY',
'PAGE3',
'WHITNEY',
'TRUTHMC',
'PARMALEE',
'CLEVEJUC',
'RACQUE',
'CRIFFSN',
'SUGARCRK',
'BESTCASE',
'TRIADIST',
'BONAPPT',
'IB111ZIN',
'IBTERDIN',
'IB016CIN',
'IB036AIN',
'IB037AIN',
'IB039AIN',
'IB044AIN',
'IB047AIN',
'IB050AIN',
'IB053BIN',
'IB054BIN',
'IB092CIN',
'IB009AKY',
'IB009CKY',
'IBR16CKY',
'IB016CKY',
'IBS16CKY',
'IB022CKY',
'IB084CKY',
'IB089CKY',
'IB084AKY',
'IB004CWV',
'IB005IWV',
'IB009CWV',
'IB009JWV',
'IB016CWV',
'IB016IWV',
'IB108LMI',
'IB011CMI',
'IB012CMI',
'IB014MMI',
'IBS14MMI',
'IB009CMI',
'IB001CMI',
'IB002AMI',
'IB002CMI',
'IB034AMI',
'IB003AWI',
'IB006AWI',
'IB006NWI',
'IBS06AWI',
'IB018OWI',
'IB028AWI',
'IBS28AWI',
'IB010AOH',
'IB011AOH',
'IB036AOH',
'IB036BOH',
'IB059AOH',
'IB084AOH',
'IB047PIN',
'IB000EIN',
'IB009CIN',
'IB001AMI',
'IB019CWV',
'PARMAN',
'NORDEN',
'PERFECT',
'IB021AOH',
'IBS34AMI',
'IB023AOH',
'IBS02CMI',
'RETSRVC',
'IB011MMI',
'FRUITMOR',
'STORERCH',
'BLUEWAT',
'PEPSPLYM',
'BLGREEN',
'HOTSTUFF',
'BFIWASTE',
'UPPERARL',
'IB040AIN',
'FIKESMAN',
'COKECLMB',
'PEPSBEDF',
'ROSSBAIT',
'PEPSBLGR',
'PEPSLAFA',
'COKECARM',
'PEPSCARM',
'PEPSMARI',
'PEPSLAWR',
'PEPSWABA',
'PEPSGRNS',
'COKEGRNS',
'PEPSCONN',
'PEPSKOKO',
'PEPSRICH',
'PEPSDEFI',
'WAUKFAIR',
'RAMBERG',
'IBSCHLD',
'IBSMSTR',
'SERRIS',
'HEISTWRT',
'KLOSTERM',
'WINEBEV',
'DUTTWAG',
'HEIJONPY',
'BEVGRT',
'ZTWHOLE',
'SEALTSJM',
'ELIZTOWN',
'BUSSING',
'PEPSFAIR',
'IBSFAIR',
'PEPSPHIL',
'COKEPHIL',
'USFOOD4',
'USFOOD5',
'REINHRT3',
'USFOOD6',
'GAWS',
'HMSWORLD',
'OSBORN',
'PEPSUSFL',
'RNZMSDNT',
'HENDBVG',
'GLENVIL2',
'BELLABRW',
'GRIFPROD',
'MAINEVEN',
'CLARKVER',
'REINHR2T',
'INSTWHIP',
'MARYANN',
'BARKETT',
'OTISPUNK',
'BREITENB',
'TROYER',
'AMISH',
'LIPARI',
'ALWAYS',
'DADDYMAC',
'SSVARBVG',
'TALMART',
'NUERA',
'CNTRYGA',
'BETRMADE',
'STANMAN',
'BURKEBVG',
'FANFARE',
'VENCREDT',
'BAKETEST',
'CONCAN',
'COUNTRYD',
'CUISINE',
'EASTCHIC',
'GOODALES',
'HOMEJC',
'JDAYDIST',
'KYDERBY',
'LATINO',
'MMBEVG',
'RIVERNOR',
'SOLARAY',
'AME',
'BAZ',
'BEA',
'BAR',
'BPA',
'BRE',
'CLA',
'PRC',
'CIR',
'CF1',
'CF',
'FRE',
'GRY',
'GAS',
'JOH',
'KAM',
'KEN',
'FLI',
'KOC',
'LEN',
'MIL',
'MOO',
'MUE',
'POR',
'PTC',
'PAU',
'SU1',
'SCH',
'USO',
'YOD',
'GARCIA',
'TORCHRIV',
'GRNBEVG',
'TOWNCTRY',
'BROUGHTW',
'MAYFIELD',
'DEANNORT',
'DEANSHAR',
'REITERAK',
'ALLIED',
'EAGLEONE',
'GAUDIO',
'ATLASBVG',
'BOONEBEV',
'ENERGYBV',
'CENTRENG',
'PETITPRN',
'EASTOWN',
'HELLMAN',
'HUBERTDI',
'MONAENG',
'BLUGRASS',
'THREESTA',
'BNBRIGHT',
'CAMPDIST',
'WEBGER',
'COLUBEVG',
'NETSPEND',
'KRAFTTST',
'HAR',
'VAL',
'NINASDNT',
'SNYHANVR',
'CIT',
'NEXXUS',
'NEXXAKRN',
'NEXXCOUR',
'COKCOLOH',
'COKDAYOH',
'COKINDIN',
'COKPRKIL',
'COKPRKWI',
'COKPTMOH',
'COKTOLOH',
'COKWILOH',
'COKZANOH',
'NEXXBULL',
'NEXXCHIC',
'NEXXDETR',
'NEXXGRAN',
'NEXXPION',
'NEXXPITT',
'NEXXPLAI',
'NEXXSUNT',
'NEXXMILW',
'NEXXCOLU',
'NEXXWISC',
'PEPAURIL',
'PEPDAYOH',
'PEPELKIL',
'GLAZIERIN',
'PEPBELWI',
'PEPLAKIL',
'PEPLAKWI',
'PEPOSHWI',
'COKBLOIN',
'PEPKANIL',
'PEPKANIN',
'PEPMETIL',
'PEPMICIN',
'PEPMUNIL',
'PEPMUNIN',
'PEPMLWWI',
'COKCINOH',
'COKAKROH',
'COKBAYMI',
'COKFINOH',
'COKFTWIN',
'COKFTWOH',
'COKKALMI',
'COKSTHIN',
'COKTERIN',
'COKCININ',
'COKCINKY',
'COKLAFIN',
'CAMPDBRD',
'JDAYDBRD',
'COKALSIL',
'COKLIMOH',
'JANSON',
'COKMADWI',
'COKNORWI',
'COKRCKWI',
'COKSHEWI',
'COKCHCIL',
'COKMLWWI',
'COKSTCIL',
'PEPSCHI4',
'FLOWEREX',
'JCDISTWV',
'TROPICJC',
'WSDEPOT',
'DUNKINTC',
'HOMECITY',
'DAWNDNT',
'OW2INC',
'CHEFSHEL',
'FABIANO',
'EARLINVO',
'PAWPINVO',
'IRONINVO',
'OHWNINVO',
'UNITINVO',
'LOUISBEV',
'REINHRT4',
'HEDINGER',
'JHNSNIN',
'SARATEST',
'HUDSONMP',
'JAC',
'BEERCPTL',
'TEX',
'BFIWAST1',
'BFISHER1',
'ARCTIC',
'NEXXOBSV',
'WISCNRCK',
'CPTLLOGN',
'HUS',
'THIRDCST',
'NEXXBUST',
'BUCKLEY',
'JWSBAIT',
'BAITTCKL',
'HOSTBRD',
'HOSTPAST',
'SKOKIEBV',
'NEXXCINC',
'TOMBS1MN',
'HBERGLOR',
'EBYEAUCL',
'IMPERIAL',
'NEXXW1MN',
'LUK',
'NQPEPMAD',
'FABILAPR',
'PEPGATR1',
'PEPGATR2',
'SPRBEVGE',
'TRAMONTE',
'REPBNATL',
'AND',
'ACQNDUMP',
'KNOWNET',
'NEXXINDY',
'NEXXLANS',
'BIMBOFDS',
'MAN',
'TOL',
'SMITHDST',
'xref-1002657',
'xref-1002658',
'BAITROBS',
'ILL',
'FRITOEPO',
'CNE',
'xref-1002664',
'BEVANDA',
'HANSENS',
'PROSPORT',
'WAUKESHA',
'NORMANDI',
'PBF',
'TOTERECN',
'HKCHEESE',
'DASDISTR',
'NEXXRIP',
'INTEGRATE',
'NEXXRACE',
'BEERHOUS',
'FISHBAIT',
'NEXXHERD',
'CHICCOMM',
'NEXXGAZ',
'WASTEMGT',
'MADISNGE',
'FLWRBAKE',
'IB046AIN',
'IB046AOH',
'IB046XIN',
'IB046AKY',
'MAD',
'AJAXTRNR',
'IDEALDST',
'IB070ATN',
'BDTBEVRG',
'PEPNSHTN',
'RSLIPMAN',
'PURITYTN',
'DETDIST',
'BUCKEYED',
'COKLVRGN',
'Old',
'PURTSUPP',
'BROSUPP1',
'BROSUPP2',
'ALLIANCE',
'DENRSUPP',
'DESHSUPP',
'CNTRSUPP',
'MAYFSUPP',
'REISUPP1',
'REISUPP2',
'SCHNSUPP',
'ALNCEBVG',
'ALLNCBVG',
'FULLCIRC',
'DEPASUPP',
'WNDYCITY',
'BARCEL',
'PEPYNGPA',
'PEPMCRPA',
'IB071APA',
'IB046AWV',
'SLUSHTRI',
'ABLIMA',
'SQUAREDO',
'TURNERDA',
'PRESCOTT',
'LINDYPPC',
'BUDCLARK',
'CARTERTN',
'BLMTN',
'PUGSINC',
'BUDCHAT',
'DEANMGLRY',
'COKCTGTN',
'TENNCRWN',
'MATADOTN',
'RBMERCH',
'IB070BTN',
'OHMULCH',
'TARVERTN',
'PEPHRMPA',
'CUMBERKY',
'MURFRSTN',
'AJAXCLRK',
'NEXXPLA2',
'IDELCHR2',
'MURFSUPP',
'LAKESHOR',
'ENGLHRDT',
'DETJKSN',
'CNTRJKSN',
'POINDXTR',
'WRUNQZNO',
'SYSCOSFL',
'MRCHQZNO',
'CHNYBLMP',
'CHNYGDFR',
'CHNYFF',
'PERKBLMP',
'PERKGDFR',
'PERKFF',
'MAINESBK',
'MDWBRKBK',
'DDMIDA',
'DDSE',
'DDNE',
'GOLDCST',
'PEPSTAFL',
'CHAMPION',
'IB072AFL',
'BORDENFL',
'DOSALTOB',
'BROWNFLA',
'NORTHFLA',
'AZSOUHFL',
'BURKHRDT',
'CECDISTR',
'NOTHBUTT',
'ROSEXP',
'PREMIER',
'NOVELBRD',
'COKCCBCC',
'HOFFCODS',
'DELPLATA',
'LOGICSDS',
'VMRPRODS',
'MCLNSUNE',
'FLORDIST',
'REDBLEDI',
'JJTAYLOR',
'PERROTT',
'CARROLL',
'COASTAL',
'STHNEAGL',
'DBGROCER',
'DAYTONA',
'JOHNSON',
'ELMEJOR',
'DBLEAGLE',
'EGLEBRND',
'STEPHENS',
'EGLEKEYS',
'BERNIE',
'SUNNYFLA',
'GLDKYLRG',
'SUNCOAST',
'NEXXFLOR',
'ARIES',
'GREATBAY',
'EVERFPGH',
'GALAXYWV',
'GCSTEGLE',
'BUDMIBVG',
'HURNDBVG',
'ROBINETT',
'PEACERVR',
'DSCSALES',
'CONEDIST',
'PEPINDST',
'CTYBEVGS',
'WAYNEDSH',
'STHRNWN',
'ROWLAND',
'DAISYBAK',
'BENARNLD',
'GARBER',
'GLDMEDAL',
'GOYAFDS',
'HESSTEMP',
'RNDCOFSC',
'JOEYSFD',
'MEDMAPS',
'MDLSWRTH',
'SSHORE',
'SPRBAKE',
'TWNSWN',
'UTZFOODS',
'WISEFDS',
'BUDCLMBA',
'HSWHOLE',
'SCSTHEGL',
'MCLNSTHE',
'MCLNPENN',
'HNRYJLEE',
'YAHNIS',
'BVGAIKEN',
'PEPSTASC',
'IB0QULTY',
'LIQDCULT',
'COMERDST',
'COKCCCSC',
'ALGEORGE',
'ABBRONX',
'MANHATAN',
'DANADIST',
'BRTOLINE',
'UNIONBR',
'COKEFLOR',
'BOENING',
'DECRSNT',
'DUTCHESS',
'NYEGLBVG',
'JOHNRYAN',
'LKBEVGE',
'KEGELPRD',
'MASSRPRD',
'OAKBVG',
'MCCRAITH',
'MCLNNTHE',
'MCLNMIDA',
'MCLNCONC',
'THECOKE',
'KAUAIFL',
'NORWICH',
'NTHRNEGL',
'ONONDAGA',
'ROCCOTST',
'SANZOSON',
'SARATOGA',
'SENECA',
'SPRTSNZN',
'COKLBRTY',
'PEPHRSPA',
'PEPPHLPA',
'PEPVENDE',
'PEPNATPA',
'PHMGMNT',
'IB0CANPA',
'IB072BPA',
'METROBVG',
'JACKJILL',
'IB0CANDV',
'SEFRDICE',
'SWISS1PA',
'TJSHEHAN',
'SWISS3PA',
'SWISS4PA',
'SWISS5PA',
'SWISS6PA',
'CREAMOPA',
'TWNTVRN',
'FLWRNVYD',
'CORNAICE',
'NUZZICE',
'HPHOODLI',
'BYRNEDNY',
'TRIVALLY',
'GUERSTEA',
'WRIGHTWS',
'COKAB3PA',
'CLOVRTEA',
'BSOROCK',
'JSHORE',
'JCKJLLIC',
'BAKEFRSH',
'NEXXPENN',
'NEXXCHBRG',
'NEXXWVIRG',
'DODAHDNT',
'KKGFLDNT',
'AZMETROB',
'CLREROSE',
'GEYSERNY',
'IB072CNY',
'MNHTHAMP',
'HPHOODNE',
'BAKRBVPA',
'PEPSNYNY',
'PEPHUDNY',
'IB0CANNY',
'PNIXBVNY',
'RIPBEVNY',
'SNAPPLNY',
'COKCORMS',
'SYSCOALB',
'SYSCOWFL',
'SYSCOJAX',
'POLARBEV',
'PRGRFOOD',
'PRAIRIEF',
'NEXXPR22',
'COKUNTSC',
'DRINKKNJ',
'JULANICE',
'ASBAKERY',
'AKTDIST',
'IB0CANNJ',
'PRAIRMFN',
'PFLDFRT',
'HIGHBVNJ',
'SEAVEWNJ',
'PEPNERNJ',
'FARISDPA',
'BDFRDBGL',
'ABUSCHCO',
'FISCHRNJ',
'LKNIFESN',
'MERRMACK',
'HORIZON',
'COLONIAL',
'SEABOARD',
'UNTDLQRS',
'BEENDLVD',
'CAPEICE',
'ATTLBICE',
'MODERNKY',
'COKNEWRI',
'NTEBEVRI',
'BAYSIDRI',
'MSAUNDR',
'FORTICE',
'RICEICE',
'ANTNUCI',
'FRMBAKE',
'GFPRDCE',
'CHEROKEE',
'EGLKNXVL',
'BEHLOG',
'BOCKFLST',
'RIVPRDCE',
'CAVALIER',
'SORBPRDC',
'FAIRPDNT',
'SANDSRV',
'AMSKEGNH',
'AMOSKEAG',
'BAYSDDST',
'BELLBVG',
'NWHMPDST',
'NHSTATLQ',
'ATLASDMA',
'GHOUSNMA',
'PEPWORMA',
'PEPLDRMA',
'STUCKEYS',
'CPTVHDGR',
'PEPNERNY',
'PEPFTZNY',
'CAPEDARY',
'TRIVALNY',
'PEPN2510',
'POLA2510',
'BALREDBL',
'DUTCHSNY',
'DANPOST',
'BEJUCECT',
'VAEAGLE',
'PEPGENNY',
'NTHNEAGL',
'PRMDSTVA',
'ATLNTCBV',
'CAFFEY',
'CSTLBVNC',
'WBORDEND',
'LONGBEVG',
'CARLPREM',
'IB072DNY',
'IB0CANVA',
'PREMIMVA',
'LOVLNDVA',
'HARRISBV',
'RHBARRNG',
'BUDASHVL',
'SKYLAND',
'HEALYWHL',
'PEPSTAVA',
'LIFTRBVA',
'NCUNITED',
'CARDSUN',
'WILSONS',
'ITLNBRD',
'BUDGREEN',
'BUDSPART',
'GENWHOLE',
'PJSDLVRY',
'WOOTTON',
'GREENCO',
'MICKEYS',
'COKCCCNC',
'SKYLNDNC',
'PIEDMONT',
'LONGBVNC',
'ALBEMRNC',
'DRPEPRNC',
'CHOICENC',
'CAROLINA',
'IB072EGA',
'BLURDGSL',
'BLURDGSW',
'LAWRNCVA',
'PEPVENNC',
'PEPHICNC',
'PEPGREEN',
'STANDARD',
'NCUNITD2',
'ADAMBVNC',
'ADAMSBVG',
'MIMSDIST',
'COKADNNC',
'SNYHNVRW',
'COKDURNC',
'BENNETT',
'SUNDROPC',
'JBBREAD',
'PEPBTLNC',
'PEPMCPNC',
'MCPHERNC',
'CRLNAEGL',
'VIRBCHBV',
'CTYBVGNC',
'SUNCODSP',
'PEPMNGNC',
'COKCCRVA',
'FOXRIVER',
'LHDISTCO',
'BTTRBRND',
'COKWSHNC',
'AMRCABAK',
'SUNDROPN',
'PEPFLORN',
'YHNSMBSC',
'MCLNDTHN',
'MCLNCRLN',
'HOFFMAN',
'DANVILLE',
'PASHORT',
'BRBWAYNE',
'MPRICEVA',
'BRBABING',
'COKCCCIN',
'TRICTYVA',
'BRBSALEM',
'PEPCVAVA',
'RCBOTWIN',
'BRBLYNCH',
'DIXIEBVG',
'LWRNCDST',
'CHESBAY',
'VAVALLEY',
'SARYDIST',
'COMERCO',
'NEXX TENN',
'COKCCCVA',
'COKNORVA',
'DRPEPRVA',
'IB072FVA',
'IB0CHMNJ',
'HAWKENPA',
'ATLANTNC',
'XYIENCTX',
'CAPBEVWV',
'BELLBVNA',
'KIRCHERPA',
'NEXXPEN3',
'COKCCCDE',
'COKCCCTN',
'PUREBEVKY',
'CRAFTNY',
'PRONTKPA',
'LEONFARM',
'UNITEDGA',
'xref-1003383',
'NRTHEAST',
'BREAKTRU',
'HCKNDSD',
'COKCCRGA',
'NEXXPEN4',
'NEXXWIS2',
'COLDFRNT',
'PEPSTMGA',
'HHDISTVA',
'SUNDROPL',
'DRPEPRTN',
'OAKMONT',
'HOFFMNVA',
'RHBUNTD',
'VAELYNCH',
'VAEPLSKI',
'VAENRTH',
'MPRICENA',
'BLURDGWB',
'WBORDMFN',
'EMPRENC',
'EMPREGA',
'GNWHLGA',
'NESTLEIC',
'LEHIGHVD',
'ASOCBND',
'ALBEMRL',
'JHNSNNC',
'WINDHAM',
'NWHMPBEV',
'COKCCCPA',
'RYMES',
'AMERPREM',
'BESTCHC',
'DARIFARM',
'SAVANNAH',
'UNTDBVGA',
'RHBARRNA',
'BNKRTFRM',
'REDBULNA',
'CARTERCHAT',
'SPRBEVNA',
'VLLYFRMS',
'WRPWING',
'PRMBEVG',
'REDBULMI',
'LAMONCA',
'CKCCRWPB',
'COKHLYWD',
'CARDIN',
'MCLNSTHW',
'DEANPET',
'TURNRMFN',
'PETIPRN',
'FABIHUBT',
'GRTLKS',
'BEVSOUTH',
'TRICTYBV',
'EGLERCK',
'HAYESRCK',
'COKANCCC',
'COKINCC',
'POWERS',
'EASTWN',
'WSTROM',
'SCHNDR',
'WNDYCTY',
'DERBYCTY',
'ARBOR',
'RAVE',
'HRNDIST2',
'WISCNSTH',
'HBGCLENA',
'NEXXFOOD',
'VANEERDN',
'CKCCCASN',
'COKABRTA',
'EUCLIDPU',
'BORDSUPP',
'OHTRNPK',
'GRAPEGRN',
'PLATFORM',
'DONNEWLD',
'COKHRTLD',
'PEPMIDIL',
'PEPMIDTN',
'DNPTSUPP',
'DEANLOU',
'CHASHER',
'DNLOUSUP',
'GALAXBR',
'RATELINER',
'DELPAPA',
'COKCHARL',
'COKSKYLD',
'COKCONWY',
'ESTONICE',
'FUHAB',
'INCOBEV',
'FUHCOOR',
'WILSON',
'VECENI',
'GALLI',
'MRSBAKER',
'RPDISTNJ',
'FAUSTDIS',
'GIANNINI',
'FARISBEV',
'BORDENTX',
'SIMPSON',
'PEPHOUTX',
'TIPPDIST',
'COKESWTX',
'COKCLAYT',
'COKFAYTV',
'COKGRNVL',
'BORDSPTX',
'COKHALFX',
'COKLELND',
'COKNBERN',
'DELIBOYS',
'IB0AMBTX',
'CLEMENTE',
'OLDCASTL',
'PDELIMA',
'HILLSIDE',
'ITHACA',
'ZWEIGLES',
'JACKHILL',
'DOLDOBRO',
'EMPRMRCH',
'AJMSSRT',
'ALLENA',
'GOETLER',
'RISENFD',
'MTNCANDY',
'STHGLZNY',
'MORGNWHL',
'ERMESINC',
'COKNEALB',
'COKNEBUF',
'COKNEELM',
'COKNEROC',
'COKNESYR',
'ALLGHENY',
'BEVDISPA',
'CAMBAKE',
'MRGNBAIT',
'TRYITDIS',
'CERTOBRO',
'HILLTOP',
'MITCHLBT',
'JEFFBAIT',
'CHICBEVG',
'YORKVIL',
'FUNBEV',
'BEVWHOLE',
'BREAKTHR',
'CLDIST',
'CAPITLBV',
'COKCHEST',
'COLLEGE',
'DDBEVRGE',
'DAHLHIMR',
'DAKTABEV',
'DAKTATOM',
'DEANFDNC',
'EASWEEN',
'PEHLRBRO',
'PETEJOYS',
'JHNSNSD',
'COKVKING',
'BARDFLWR',
'PRAIRIE',
'LITKBAIT',
'BELLBOY',
'BERNICK',
'MAMUNDSN',
'LANGBAIT',
'JASONICE',
'NRTHBAIT',
'COKDULTH',
'PANOGOLD',
'UPPERLAK',
'SANDSTRM',
'DOZENDON',
'BIMBO',
'LEENALUR',
'DAKTANEW',
'MOVIEBUY',
'ZHAUL',
'AMRBOTCO',
'BILLDIST',
'BROWNSIC',
'CANNONTK',
'CAPPTSMK',
'CRAFTDIS',
'CSTDIST',
'DAYLIGHT',
'EARLFOOD',
'GENERAL',
'PEPGILET',
'COKGREAT',
'HBOYDNEL',
'HEGGIES',
'HIGHDIST',
'HOHENSTN',
'ICEECO',
'JJTAYMN',
'LACROSSE',
'LAKESGAS',
'LEEBEVWI',
'LOCHERBR',
'LYNCODIS',
'MCDONALD',
'MCDMEAT',
'NILSSEN',
'NOVELTY',
'VIKINGBV',
'TOWDIST',
'ARTISAN',
'PHILIPWN',
'GLAZERMN',
'WINECOMP',
'VINOCOPA',
'WNMERCH',
'SYSCOWMN',
'BEAUDRY',
'MICHAUD',
'BEECHWD',
'NRTHWOOD',
'SPRBEVMN',
'SRATGALQ',
'SUNNYHIL',
'WOODBURY',
'KTCHNFD',
'HNRYFLRL',
'PEPSIBEV',
'JHNSNLQ',
'PAUSTIS',
'CURTISCO',
'DEGLRMFN',
'DUTCHMN',
'BERNIWI',
'SPRBEVLQ',
'SMOMSAND',
'SMOMPKGD',
'SMOMFRSH',
'SMOMCFO',
'WHITESB',
'CORTLAN',
'BERNINO',
'BERNALC',
'COKNECCD',
'COKNELDY',
'COKNELSR',
'COKNELWL',
'COKNESCT',
'COKNEWTD',
'SHAMRCK',
'ALTWAST',
'BEALDIST',
'CNYWOOD',
'ARCADIA',
'BOXESBA',
'CEDARIC',
'PINERIV',
'DEBLASIO',
'ERIEPA',
'BUDDISAL',
'BAITGUY',
'MORELLI',
'KOERNER',
'SEMRKTD',
'DARIDFO',
'SWNSNS',
'WADHRT',
'VPXDSD',
'JCKSWH',
'MADBOT',
'GSKMYR',
'STHNGLFL',
'GULFDIST',
'RHINGEST',
'BRKTHRLQ',
'TOMDNTS',
'PRFRMANC',
'CASHWA',
'MCLNOCAL',
'NYMILLS',
'RHBRALGH',
'SKIBEER',
'INNVOFFC',
'EDMDIST',
'BRBBOSTN',
'CLAIRMON',
'CLDFRONT',
'PEPSIRIP',
'RAJEFFRY',
'RAJRAL',
'RAJWILM',
'TOMSDNT',
'ADMRLBEV',
'ADMRLGAL',
'ALABEV',
'ALCRDUR',
'AQUASAL',
'ARJENCIA',
'AZSELECT',
'BENKTHFD',
'BEVSROME',
'BHWHLSL',
'BORDENAL',
'BORDSPAL',
'BRKTHRU',
'BURKDSMA',
'CANYON',
'CAPECOD',
'CASELLA',
'COKCOL',
'COKSNTFE',
'COKSWIRE',
'COKUNTAL',
'COLEAGLE',
'CREAMLND',
'CROWNBSC',
'CRSNTCR',
'CSTCLOU',
'DALESNOV',
'DOUGSTR',
'FNLYTSCN',
'FRRLLGAS',
'HARRISNC',
'HENSLEY',
'HGHPOINT',
'ICEE',
'KALIL',
'KEUTEN',
'LAKEMAP',
'LFDSTCVO',
'LFDSTROS',
'MNNYPSTR',
'NTNLDIST',
'NTNLGAL',
'NWSNRSE',
'PEPBUFAL',
'PEPSW',
'PRCSCRMR',
'PREMDST',
'PREMGAL',
'PREMRCVO',
'REDDYICE',
'SKABRWNG',
'STHGLZAZ',
'STHGLZNM',
'STHGZGAL',
'STHRNAZ',
'STMPCOM',
'SUNDROTP',
'SWBEVG',
'SWICE',
'SYSCONM',
'UNITDPO',
'VILLALBS',
'WHTMTN',
'YNGSMKT',
'ZUMADIST',
'OHLOTTRY',
'AZLOTTRY',
'ALEJTORT',
'CHFPRPNE',
'DMFBAIT',
'DOLLDST',
'DONUTKRZ',
'GLZRBRTX',
'LEGACYB',
'LFDSTELP',
'MDWGLD',
'ORION',
'PEPNORAZ',
'PEPSFFRD',
'PREMRAZ',
'PREMRTX',
'ROMERBEV',
'SCHDIST',
'SIECKFLO',
'SPRBEVWI',
'SYSCOSYR',
'THRCNTS',
'TORTPUEB',
'UPSNIAG',
'BENKTH',
'CLDSPRNG',
'COKDRNGO',
'CONCRDFD',
'CRLSICE',
'DONTPDLR',
'LAKEWOOD',
'NYTHRUWY',
'REDBULMN',
'REPNATTX',
'SHMRCKFD',
'SUNNYSKY',
'WILBDIST',
'DOLLBEV',
'PEPTWIN',
'REDBULL',
'FRIESSES',
'MIDAMERI',
'ACEICECO',
'AMERMFG',
'AMEXPRES',
'AMRICE',
'ANOKA',
'ARGUS',
'ARNESON',
'BADGER',
'BEERCENT',
'BLUERHINO',
'BRAINERD',
'BULLETIN',
'BUNDLES',
'BURNETT',
'BUSTED',
'CARGILL',
'CARHARTT',
'CASEYNEW',
'CBDIST',
'CENTRLWD',
'CNRTYMT',
'DALENEWS',
'DOOLEYS',
'DUNLAY',
'ECHOPUB',
'EILEENS',
'FACMOTOR',
'FAIRNEWS',
'FIREHOUS',
'GRANDY',
'HAPPYGR',
'HEGERS',
'HOPBAREL',
'INDPNDNT',
'JEROMES',
'JIMCHEES',
'JOHNFEED',
'JPRDIST',
'KATHFUEL',
'KINCO',
'KRIEGER',
'LAIDLAW',
'LAKEDIST',
'LEDGER',
'LESUER',
'LINKSNCK',
'LIQUIDMN',
'LIVEWIRE',
'MIDWEST',
'MSDISTR',
'NEBOLGHT',
'NEEDHAM',
'NRTHNBAT',
'PEPCHAM',
'PEPESTHR',
'PEPMANK',
'PEPPBC',
'PEPROCH',
'PIONEER',
'PLMADIST',
'POLKADOT',
'PRESSTME',
'PRGUETIM',
'QUALITY',
'REDWING',
'REPEAGLE',
'RICHMOND',
'RJOUTDOR',
'RONNOCO',
'SARALEE',
'SCHROEDR',
'SENTINEL',
'SMOMALL',
'STAROBSR',
'STARTRIB',
'STCLOUD',
'SWIFTCO',
'TOWDISTR',
'TREATPL',
'TRIANGLE',
'TRISTAR',
'TWINDIST',
'USATODAY',
'VALLYNEW',
'VONHANSN',
'WESTCENT',
'WILLOW',
'WILLSON',
'WNTRCRNV',
'WOODWICK',
'WRTHNGTN',
'XTREME',
'ALLSPORT',
'AMBASSDR',
'AMRDIST',
'AMSOIL',
'ANDERSON',
'BERN',
'BERNTELO',
'BESTOIL',
'BLDIST',
'BUFFGLO',
'CARDSUCH',
'CHAMBERL',
'CHOCSTRY',
'CITIBAIT',
'CLAIRS',
'CNRTYPT',
'COCACOLA',
'CRYSTAL',
'DUKEDIST',
'DULTHTRI',
'EARTHGRN',
'EPAY',
'ETVIDEO',
'FARNER',
'FEDDICK',
'FEDERATD',
'FIREWOOD',
'FREEPRES',
'FRMERBRO',
'GIOVANNI',
'GREENVAL',
'GRTCHEES',
'HAGENBEV',
'HASTINGS',
'HENDERSN',
'HERITAGE',
'HOSTESS',
'HUDSON',
'HUSNIK',
'HUTCHIN',
'IGOG',
'JACOLLC',
'JANDC',
'JAXFIRE',
'JAYSTUFF',
'JIMDANDY',
'KEMPSLLC',
'KENSBAIT',
'KINGDIST',
'LANDMARK',
'LEANINTR',
'LEEPUB',
'LEEWESVN',
'MDDISTR',
'MNFIREWD',
'NEWGROUP',
'NRTHSALT',
'PARAMONT',
'PEPPIPE',
'PETTREAT',
'PIZCORNR',
'PIZZAHUT',
'PRECISE',
'PREMRPRO',
'RIVRCOOP',
'RIVRTOWN',
'RJMDIST',
'ROHLFING',
'SCHTDIST',
'SCHWANS',
'SDCOFFEE',
'SEAVERCO',
'SHEARER',
'SOUTHWST',
'TOURICE',
'TWINGRT',
'VETSOIL',
'WATERVIL',
'WATSONS',
'WELDAIRY',
'WENNER',
'WHTBEAR',
'WINNERCO',
'WOODCHCK',
'WRGHTPRS',
'CRMKALBQ',
'CRMKBKFD',
'CRMKCRNA',
'CRMKHWRD',
'CRMKLAXX',
'CRMKSCRM',
'EBYMONTY',
'EBYPLNFD',
'EBYLBRTY',
'EBYSHPVL',
'EBYSPGFD',
'EBYYPSIL')

SELECT ISNULL(xref_code, 'xref-' + CONVERT(NVARCHAR(15),s.supplier_id)) AS XRefCode,
REPLACe(s.name,',','~') AS Name
FROM Supplier as s
JOIN @Supplier AS s2
ON   s.supplier_id = s2.supplier_id
LEFT JOIN Address as a
ON s.address_id = a.address_id

ORDER by s.xref_code
GO
