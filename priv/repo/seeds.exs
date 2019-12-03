# Script for populating the database. You can run it as:
#
#   mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#   Parking.Repo.insert!(%Parking.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Parking.{Repo, UserManager, Zone}

# seed customers
[%{username: "ivan", password: "123"},
 %{username: "andrey", password: "123"}]
|> Enum.map(fn user_data -> UserManager.create_user(user_data) end)

# seed zones
zoneP = Repo.insert!(%Zone{name: "pedestrian", hourPayment: 0.0, realTimePayment: 0.0, freeFirstMinutes: 0})
zoneA = Repo.insert!(%Zone{name: "A", hourPayment: 2.0, realTimePayment: 0.16, freeFirstMinutes: 15})
zoneB = Repo.insert!(%Zone{name: "B", hourPayment: 1.0, realTimePayment: 0.08, freeFirstMinutes: 90})
zoneF = Repo.insert!(%Zone{name: "free", hourPayment: 0.0, realTimePayment: 0.0, freeFirstMinutes: 0})

# seed parkings
[%{capacity:  20, location: "58.387746,26.696940", timelimit: 0, area: "58.38811045707349,26.697406020617336 58.38760994822571,26.696209755396694 58.387022263039675,26.69730409667477 58.387601512622474,26.698371615862698"},
 %{capacity:  20, location: "58.382548,26.709504", timelimit: 0, area: "58.38273009407792,26.70879321461109 58.3822857547534,26.709758809856453 58.38238137254904,26.709962657741585 58.38281446167178,26.708943418315926"},
 %{capacity:  20, location: "58.379579,26.708482", timelimit: 0, area: "58.37976392189816,26.70835325396729 58.379589546902395,26.70809576190186 58.37939829591593,26.70855710185242 58.379592359409166,26.70881995833588"},
 %{capacity:  20, location: "58.375073,26.704905", timelimit: 0, area: "58.375187675534306,26.70429053980945 58.37475449277052,26.704848439284547 58.374968271941995,26.705663830825074 58.37539582639919,26.704880625792725"},
 %{capacity:  20, location: "58.373601,26.708788", timelimit: 0, area: "58.373645304475154,26.708039663684872 58.37405599727952,26.708962343585995 58.37354685001037,26.709729455364254 58.37317272053872,26.70881750429919"},
 %{capacity:  20, location: "58.369655,26.714181", timelimit: 0, area: "58.370088948685975,26.71354263425451 58.369931405533634,26.713708931213432 58.36963601022735,26.713569456344658 58.36867384837271,26.71496956945043 58.368837023867684,26.715430909400993 58.369309665871405,26.714819365745598 58.369405318840094,26.715162688499504 58.36963601022735,26.71479790807348 58.369996110842045,26.71576350331884 58.37056438714966,26.714873009925896"},
 %{capacity:  20, location: "58.372646,26.720490", timelimit: 0, area: "58.37295899586714,26.720323683172637 58.372511720388246,26.72099959984439 58.37234293571528,26.72052753105777 58.37281271771805,26.719905258566314"},
 %{capacity:  20, location: "58.370602,26.726183", timelimit: 0, area: "58.370483141111265,26.725466850193015 58.37036498513276,26.725654604824058 58.370567537996536,26.726480725200645 58.37070257259315,26.72631442824172"},
 %{capacity:  20, location: "58.380054,26.731616", timelimit: 0, area: "58.3800068910985,26.73109565145114 58.37980157992757,26.731326321426423 58.3801447020362,26.732533315483124 58.380442821814384,26.732302645507843 58.38040063520635,26.73187349206546 58.38027688753175,26.731929818454773"},
 %{capacity:  20, location: "58.379745,26.738621", timelimit: 0, area: "58.379926316459176,26.738405079692825 58.37974912977211,26.73831924900435 58.379569129686644,26.738705487102493 58.37915006342946,26.738587469905838 58.37912475054307,26.73876449570082 58.379768817225724,26.73900589451216"},
 %{capacity:  20, location: "58.378639,26.738794", timelimit: 0, area: "58.378522741011295,26.739483260257657 58.378853219015824,26.738598131282743 58.37850024026865,26.738351368053372"},
 %{capacity:  20, location: "58.378335,26.738633", timelimit: 0, area: "58.37842992535532,26.73837819014352 58.37815007061144,26.738429152114804 58.37844961354519,26.739209674938138"},
 %{capacity:  20, location: "58.377931,26.742865", timelimit: 0, area: "58.37808358534189,26.742172990074096 58.37748449071527,26.743256602516112 58.378412661159956,26.745461378326354 58.37851672723282,26.745203886260924 58.37780794682425,26.743634793987212 58.378333908252124,26.742741618385253"},
 %{capacity:  20, location: "58.378844,26.740198", timelimit: 0, area: "58.378954528324584,26.74031891187633 58.378781555613614,26.739828067626604 58.378695772084626,26.740026551093706 58.37885186982608,26.740482526626238"},
 %{capacity:  20, location: "58.371382,26.715311", timelimit: 120, area: "58.37171606131326,26.715249309192586 58.37148819667615,26.714651176582265 58.37111404537681,26.715182253967214 58.371350351922146,26.71579379762261"},
 %{capacity:  20, location: "58.380832,26.729075", timelimit: 120, area: "58.38106613217444,26.72893552513119 58.380966292218034,26.728624388885464 58.38078207972577,26.72886846990582 58.38066958307418,26.728675350856747 58.380548648773576,26.72887919874188 58.380769423870376,26.72935663194653"},
 %{capacity:  20, location: "58.379130,26.728010", timelimit: 60, area: "58.37829818044693,26.72876638294224 58.37877350830749,26.729678334007303 58.37915460974724,26.728935362110178 58.37932758062905,26.727859796295206 58.37913632822237,26.72748965145115"},
 %{capacity:  20, location: "58.379515,26.716033", timelimit: 0, area: "58.37996007734702,26.714683848865548 58.379847578073964,26.71459265375904 58.37956632832174,26.71486087466053 58.37971539096971,26.7151076378899 58.37940038991616,26.71616442824177 58.379138824403825,26.71590157175831 58.3790853860498,26.71615906382374 58.37944257772037,26.716566759594002"},
 %{capacity:  20, location: "58.382568,26.716274", timelimit: 0, area: "58.38275009397467,26.715834117721556 58.38257995214299,26.71571073610687 58.38240699720848,26.71644566137695 58.382599638016735,26.716665602516173"},
 %{capacity:  20, location: "58.380171,26.721308", timelimit: 0, area: "58.380249045693304,26.721431381614707 58.379739987791474,26.72183371296694 58.37970623783665,26.721672780426047 58.38019560902107,26.720911033065818"},
 %{capacity:  20, location: "58.381113,26.722843", timelimit: 0, area: "58.38115588885162,26.72251845270921 58.3806862179305,26.72296906382371 58.38079308970766,26.723414310520184 58.38126275920582,26.72297442824174"},
 %{capacity:  20, location: "58.381385,26.724239", timelimit: 0, area: "58.38189437670598,26.72348162497849 58.380789116402745,26.724334567445226 58.38087067623454,26.724801271813817 58.38198155861507,26.72422727908463"},
 %{capacity:  20, location: "58.376916,26.725434", timelimit: 0, area: "58.37677610522069,26.726091275911244 58.37661577917878,26.725849877099904 58.37727676781946,26.72472871373168 58.37740052601833,26.725093494157704"},
 %{capacity:  20, location: "58.379342,26.734488", timelimit: 0, area: "58.37940647287469,26.734157805869245 58.378888965126734,26.73506439251628 58.37830394722655,26.73504829926219 58.37830394722655,26.736389403769635 58.37868646002839,26.736357217261457 58.37946834829294,26.7362392000648 58.37972991136202,26.73506439251628"},
 %{capacity:  20, location: "58.375328,26.736195", timelimit: 0, area: "58.37555513663468,26.736602695770216 58.37523728557938,26.736693890876722 58.37467471032093,26.73511943418498 58.374851922495104,26.734666140861464 58.37522603416215,26.734312089271498"}
]
|> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneF, :parkings, data)) end)

# seed streets
streetsZoneP = [
 %{name: "Raekoja plats", capacity:  0, area: "26.7251015,58.3805460 26.7215395,58.3799273"},
 %{name: "Küüni", capacity:  0, area: "26.7227626,58.3799948 26.7235565,58.3792636 26.7270756,58.3772047"},
 %{name: "Rüütli", capacity:  0, area: "26.7223763,58.3802423 26.7213249,58.3820985"},
 %{name: "Küütri", capacity:  0, area: "26.7205095,58.3807823 26.7233634,58.3812885"}
]
streetsZoneA = [
 %{name: "Vabaduse puiestee", capacity:  60, area: "26.7288780,58.3780035 26.7254663,58.3799948 26.7232561,58.3841120"},
 %{name: "Kompanii", capacity:  14, area: "26.7227840,58.3823347 26.7233205,58.3812323 26.7243290,58.3805235"},
 %{name: "Magasini", capacity:  18, area: "26.7212820,58.3837746 26.7215824,58.3834484 26.7217541,58.3822222"},
 %{name: "Jaani", capacity:  18, area: "26.7185354,58.3832515 26.7194366,58.3826159 26.7200589,58.3819297"},
 %{name: "Munga", capacity:  40, area: "26.7239857,58.3825428 26.7200375,58.3819354 26.7181921,58.3813673"},
 %{name: "Gildi", capacity:  30, area: "26.7242968,58.3819072 26.7203379,58.3815754"},
 %{name: "Jakobi", capacity:  30, area: "26.7186105,58.3810523 26.7178380,58.3815810 26.7165506,58.3821266 26.7110682,58.3829815 26.7098236,58.3833977 26.7092228,58.3836227"},
 %{name: "Lutsu", capacity:  25, area: "26.7193937,58.3826272 26.7189002,58.3824697 26.7173445,58.3817779"},
 %{name: "Karl Ernst von Baeri", capacity:  60, area: "26.7144907,58.3824247 26.7141366,58.3820703 26.7130744,58.3816935 26.7125165,58.3813729 26.7126131,58.3808610 26.7129457,58.3802985 26.7129350,58.3799161 26.7125273,58.3792073 26.7125380,58.3789598 26.7129242,58.3788304 26.7135680,58.3787967 26.7154670,58.3787010 26.7156172,58.3786560"},
 %{name: "Lossi", capacity:  20, area: "26.7209601,58.3802367 26.7164433,58.3793311 26.7156386,58.3786560"},
 %{name: "Vallikraavi", capacity:  20, area: "26.7232239,58.3784479 26.7229235,58.3783185 26.7224836,58.3779135 26.7221296,58.3778741 26.7206597,58.3780373 26.7197907,58.3780541 26.7185569,58.3778741 26.7175055,58.3776210 26.7171836,58.3776604 26.7160034,58.3784760 26.7156386,58.3786673"},
 %{name: "Ülikooli", capacity:  30, area: "26.7260671,58.3766647 26.7230818,58.3785534 26.7225561,58.3790540 26.7217112,58.3797361 26.7209977,58.3801776 26.7209333,58.3802465 26.7208984,58.3803590 26.7205095,58.3807865 26.7203057,58.3814798 26.7203432,58.3815782 26.7200562,58.3819354"},
 %{name: "Uueturu", capacity:  10, area: "26.7275798,58.3786560 26.7249835,58.3773735"},
 %{name: "Poe", capacity:  10, area: "26.7255521,58.3800229 26.7225802,58.3790442"}
]
streetsZoneB = [
 %{name: "Kroonuaia", capacity:  50, area: "26.7213571,58.3860636 26.7183208,58.3844101 26.7158532,58.3839377 26.7144907,58.3824359"},
 %{name: "Kloostri", capacity:  8, area: "26.7168832,58.3840895 26.7181385,58.3831671"},
 %{name: "Tähtvere", capacity:  20, area: "26.7103386,58.3850119 26.7113900,58.3844607 26.7127848,58.3835158 26.7144263,58.3825934 26.7145121,58.3824528"},
 %{name: "Oru", capacity:  8, area: "26.7125005,58.3813645 26.7115831,58.3815191 26.7109555,58.3815641 26.7105371,58.3819213 26.7098880,58.3821997 26.7097270,58.3823797 26.7088795,58.3827847"},
 %{name: "Veski", capacity:  50, area: "26.7110896,58.3829647 26.7095661,58.3820985 26.7093515,58.3798261 26.7100167,58.3792073 26.7121840,58.3765634 26.7122054,58.3763384"},
 %{name: "Näituse", capacity:  60, area: "26.7069483,58.3786785 26.7116904,58.3796123 26.7126989,58.3796123"},
 %{name: "Juhan Liivi", capacity:  20, area: "26.7156386,58.3786617 26.7152417,58.3784985 26.7133105,58.3785548 26.7127526,58.3784817 26.7109716,58.3780204"},
 %{name: "Kastani", capacity:  60, area: "26.7108643,58.3762596 26.7090833,58.3790554"},
 %{name: "Kooli", capacity:  16, area: "26.7087293,58.3758827 26.7069054,58.3786617"},
 %{name: "Anna Haava", capacity:  20, area: "26.7067552,58.3753258 26.7047489,58.3782679"},
 %{name: "Vabriku", capacity:  8, area: "26.7029786,58.3765915 26.7055428,58.3770585"},
 %{name: "Jaan Tõnissoni", capacity:  20, area: "26.7055535,58.3749714 26.7087400,58.3758940 26.7096305,58.3761246 26.7099524,58.3761978 26.7103493,58.3762203 26.7107141,58.3762090"},
 %{name: "Julius Kuperjanovi", capacity:  20, area: "26.7073667,58.3741275 26.7105639,58.3760740 26.7107463,58.3761415"},
 %{name: "Tiigi", capacity:  80, area: "26.7086649,58.3729854 26.7211103,58.3774635 26.7213678,58.3772497"},
 %{name: "Vaksali", capacity:  20, area: "26.7101455,58.3721302 26.7055750,58.3749770"},
 %{name: "Vanemuise", capacity:  100, area: "26.7249942,58.3773735 26.7168832,58.3738968 26.7147803,58.3731204 26.7101240,58.3721528"},
 %{name: "Õpetaja", capacity:  8, area: "26.7149520,58.3752414 26.7157781,58.3744144 26.7182136,58.3752583"},
 %{name: "Pepleri", capacity:  8, area: "26.7173982,58.3761303 26.7203164,58.3730754"},
 %{name: "Akadeemia", capacity:  16, area: "26.7192650,58.3768166 26.7197800,58.3763553 26.7208529,58.3756183 26.7230201,58.3742175"},
 %{name: "Wilhelm Struve", capacity:  8, area: "26.7224193,58.3763159 26.7239642,58.3748870"},
 %{name: "Võru", capacity:  100, area: "26.7230415,58.3741669 26.7228162,58.3728954 26.7222583,58.3720740"},
 %{name: "Väike-Tähe", capacity:  10, area: "26.7222691,58.3720571 26.7226553,58.3719896 26.7235672,58.3719615 26.7260563,58.3723665"},
 %{name: "Tahe", capacity:  60, area: "26.7230415,58.3742006 26.7234492,58.3741162 26.7252088,58.3735311 26.7271936,58.3707912"},
 %{name: "Lille", capacity:  20, area: "26.7242002,58.3747182 26.7251015,58.3744650 26.7283952,58.3751795"},
 %{name: "Päeva", capacity:  18, area: "26.7263138,58.3720233 26.7290068,58.3728954"},
 %{name: "Pargi", capacity:  22, area: "26.7271829,58.3707631 26.7274511,58.3708418 26.7276335,58.3710613 26.7283523,58.3714663 26.7286742,58.3718658 26.7294252,58.3720627 26.7304552,58.3721753 26.7320859,58.3723497"},
 %{name: "Kalevi", capacity:  30, area: "26.7284274,58.3751908 26.7286634,58.3750389 26.7316997,58.3726535"},
 %{name: "Lao", capacity:  6, area: "26.7293823,58.3744369 26.7308414,58.3750276"},
 %{name: "Aida", capacity:  16, area: "26.7356801,58.3740093 26.7317104,58.3726591"},
 %{name: "Aleksandri", capacity:  60, area: "26.7288244,58.3761978 26.7336309,58.3733005"},
 %{name: "Sadama", capacity:  10, area: "26.7320430,58.3763103 26.7332017,58.3768391"},
 %{name: "Kaluri", capacity:  10, area: "26.7317533,58.3776547 26.7332017,58.3768222"}
]

streetsZoneP |> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneP, :streets, data)) end)
streetsZoneA |> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneA, :streets, data)) end)
streetsZoneB |> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneB, :streets, data)) end)
