import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:zandoprintapp/ui/widgets/submit_btn.dart';
import '../../models/item.dart';
import '../../services/api.dart';
import '/services/utils.dart';
import '/ui/widgets/dashline.dart';
import '../../global/controllers.dart';
import '../../models/client.dart';
import '../../models/facture.dart';
import '../../models/facture_detail.dart';
import '../widgets/custom_btn_icon.dart';
import '/ui/modals/public/client_filter_modal.dart';
import '../../config/utils.dart';
import '/ui/components/custom_appbar.dart';
import '/ui/widgets/custom_field.dart';

class FactureCreatePage extends StatefulWidget {
  const FactureCreatePage({super.key});

  @override
  State<FactureCreatePage> createState() => _FactureCreatePageState();
}

class _FactureCreatePageState extends State<FactureCreatePage> {
  Client? selectedClient;
  List<FactureDetail> items = <FactureDetail>[];

  Item? selectedItem;
  Nature? selectedNature;
  List<Nature> natures = [];
  final itemPrice = TextEditingController();
  final itemQty = TextEditingController();
  String itemDevise = "USD";

  double total = 0.0;
  double currentTot = 0.0;

  bool submitLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void refreshSum() {
    for (var e in items) {
      if (e.factureDetailDevise == "CDF") {
        currentTot = convertCdfToDollars(e.total);
      } else {
        currentTot = e.total;
      }
      total += currentTot;
    }
  }

  void addFactureItems() {
    if (selectedItem == null) {
      EasyLoading.showToast("Veuillez sélectionner un item !");
      return;
    }
    if (selectedNature == null) {
      EasyLoading.showToast("Veuillez sélectionner une nature !");
      return;
    }
    if (itemQty.text.isEmpty) {
      EasyLoading.showToast("Veuillez entrer la quantité du produit !");
      return;
    }
    try {
      var item = FactureDetail(
        factureDetailLibelle: selectedItem!.itemLibelle!,
        factureDetailNature: selectedNature!.itemNatureLibelle,
        factureDetailPu: itemPrice.text.replaceAll(',', '.'),
        factureDetailQte: itemQty.text.replaceAll(',', '.'),
        factureDetailDevise: itemDevise,
      );
      bool exists = items.contains(item);
      if (exists) {
        EasyLoading.showToast("Sélection existe déjà dans la liste !");
        return;
      }
      setState(() {
        items.add(item);
        refreshSum();
        Item? i;
        Nature? n;
        itemDevise = "";
        itemPrice.text = "";
        itemQty.text = "";
        selectedItem = i;
        selectedNature = n;
        natures.clear();
      });
    } catch (e) {
      EasyLoading.showToast("Veuillez verifier les données entrées !");
      return;
    }
  }

  void createFacture() async {
    if (selectedClient == null) {
      EasyLoading.showInfo(
          "Veuillez créer des items pour la facture avant d'effectuer cette action !");
      return;
    }
    if (items.isEmpty) {
      EasyLoading.showInfo(
          "Veuillez créer des items pour la facture avant d'effectuer cette action !");
      return;
    }
    double total = 0.0;
    double currentTot = 0.0;
    for (var e in items) {
      if (e.factureDetailDevise == "CDF") {
        currentTot = convertCdfToDollars(e.total);
      } else {
        currentTot = e.total;
      }
      total += currentTot;
    }
    //create facture statment. //
    var facture = Facture(
      factureClientId: selectedClient!.clientId,
      factureDevise: "USD",
      factureMontant: total.toStringAsExponential(2),
    );
    setState(() => submitLoading = true);
    List<Map<String, dynamic>> itemsJsonList =
        items.map((item) => item.toMap()).toList();
    Api.request(url: 'facture.create', method: 'post', body: {
      "facture_montant": facture.factureMontant,
      "facture_devise": facture.factureDevise,
      "client_id": int.parse(selectedClient!.clientId!.toString()),
      "user_id": int.parse(authController.user.value.userId.toString()),
      "facture_details": itemsJsonList,
    }).then((res) {
      setState(() => submitLoading = false);
      if (res.containsKey('status')) {
        if (res['status'] == "success") {
          setState(() {
            items.clear();
            selectedClient = null;
          });
          EasyLoading.showSuccess("Facture créée avec succès !");
          dataController.loadFilterFactures("pending");
          dataController.loadFilterFactures("all");
        }
      } else {
        EasyLoading.showInfo("Echec de traitement des informations !");
        return;
      }
    }).catchError((onError) {
      EasyLoading.showInfo(
          "Une erreur est survenue lors de l'envoie des informations au serveur !");
      setState(() => submitLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Nouvelle facture"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: _actionBtn(
                      hintText: "Sélectionnez un client",
                      value: selectedClient != null
                          ? selectedClient!.clientNom!
                          : null,
                      icon: CupertinoIcons.person,
                      onClear: () {
                        setState(() {
                          selectedClient = null;
                        });
                      },
                      onTap: () {
                        showClientFilterModal(context, onSelected: (client) {
                          setState(() {
                            selectedClient = client;
                          });
                        });
                      }),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomField(
                    hintText: "--Sélectionnez un item--",
                    iconPath: "assets/icons/label.svg",
                    isDropdown: true,
                    dropItems: dataController.items,
                    selectedValue: selectedItem,
                    onChangedDrop: (val) {
                      Nature? nature;
                      setState(() {
                        selectedNature = nature;
                        selectedItem = val;
                        natures = List.from(selectedItem!.natures!);
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                SizedBox(
                  width: 200.0,
                  child: CustomField(
                    hintText: "--Nature--",
                    iconPath: "assets/icons/price.svg",
                    isDropdown: true,
                    dropItems: natures,
                    selectedValue: selectedNature,
                    onChangedDrop: (val) {
                      setState(() {
                        selectedNature = val;
                        itemPrice.text = selectedNature!.itemNaturePrix!;
                        itemDevise = selectedNature!.itemNaturePrixDevise!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Flexible(
                  child: CustomField(
                    hintText: "Prix unitaire",
                    readOnly: true,
                    inputType: TextInputType.number,
                    iconPath: "assets/icons/money.svg",
                    controller: itemPrice,
                    fixeDevise: itemDevise,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Flexible(
                  child: CustomField(
                    hintText: "Quantité",
                    inputType: TextInputType.number,
                    iconPath: "assets/icons/measure.svg",
                    controller: itemQty,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: primaryColor,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        addFactureItems();
                      },
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.add,
                          size: 16,
                          color: lightColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (items.isNotEmpty) ...[
              _factureDetails(context),
            ] else ...[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Center(
                    child: Text(
                      "Veuillez créer une facture en y ajoutant des détails !",
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _factureDetails(context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "Libellé",
                  style: TextStyle(
                    color: defaultTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  "Nature",
                  style: TextStyle(
                    color: defaultTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  "P.U",
                  style: TextStyle(
                    color: defaultTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  "Quantité",
                  style: TextStyle(
                    color: defaultTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  "Total",
                  style: TextStyle(
                    color: defaultTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  "",
                  style: TextStyle(
                    color: defaultTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ),
        const DashedLine(
          height: 1.0,
          color: Colors.grey,
        ),
        for (var item in items) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 2.0),
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      item.factureDetailLibelle!,
                      style: const TextStyle(
                        color: defaultTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      item.factureDetailNature!,
                      style: const TextStyle(
                        color: defaultTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: item.factureDetailPu!.padLeft(2, "0"),
                            style: const TextStyle(
                              color: defaultTextColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " ${item.factureDetailDevise}",
                            style: const TextStyle(
                              color: defaultTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      item.factureDetailQte.toString().padLeft(2, "0"),
                      style: const TextStyle(
                        color: defaultTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: item.total.toStringAsFixed(2).padLeft(2, "0"),
                            style: const TextStyle(
                              color: defaultTextColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " ${item.factureDetailDevise}",
                            style: const TextStyle(
                              color: defaultTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      tooltip: "Retirer l'item !",
                      onPressed: () {
                        int index = items.indexOf(item);
                        setState(() {
                          items.removeAt(index);
                          refreshSum();
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                      iconSize: 15.0,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          ),
          DashedLine(
            color: Colors.grey.shade700,
            height: .4,
            space: 2,
          )
        ],
        Row(
          children: [
            Flexible(
              child: SizedBox(
                height: 82.0,
                width: MediaQuery.of(context).size.width,
                child: SubmitButton(
                  loading: submitLoading,
                  color: Colors.green,
                  onPressed: () {
                    createFacture();
                  },
                  icon: Icons.add,
                  label: "Valider & créer facture",
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TotItem(
                      title: "Net à payer",
                      value: total.toStringAsFixed(2),
                      currency: "USD",
                      color: defaultTextColor,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TotItem(
                      title: "Equivalent en CDF",
                      value: convertDollarsToCdf(total).toStringAsFixed(2),
                      currency: "CDF",
                      color: defaultTextColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _actionBtn(
      {VoidCallback? onTap,
      VoidCallback? onClear,
      IconData? icon,
      String? hintText,
      String? value}) {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: .8,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: primaryColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                if (value != null) ...[
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: defaultTextColor,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomBtnIcon(onPressed: onClear!),
                ] else ...[
                  Text(
                    hintText!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontFamily: defaultFont,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TotItem extends StatelessWidget {
  final String? title;
  final String? value;
  final String? currency;
  final Color? color;
  const TotItem({
    super.key,
    this.value,
    this.currency,
    this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        color: lightColor,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$title : ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: " $value ",
                      style: TextStyle(
                        color: color ?? Colors.black,
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                      ),
                    ),
                    TextSpan(
                      text: " $currency",
                      style: TextStyle(
                        color: color,
                        fontSize: 10.0,
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
