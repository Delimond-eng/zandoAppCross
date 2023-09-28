class Menu {
  String? title;
  String? icon;
  Menu({this.title, this.icon});
}

final List<Menu> menus = [
  Menu(
    icon: "assets/icons/dashboardii.svg",
    title: "Tableau de bord",
  ),
  Menu(
    icon: "assets/icons/costumer.svg",
    title: "Clients",
  ),
  Menu(
    icon: "assets/icons/facture.svg",
    title: "Factures",
  ),
  Menu(
    icon: "assets/icons/money-receive.svg",
    title: "Paiements",
  ),
  Menu(
    icon: "assets/icons/wallet.svg",
    title: "Trésoreries",
  ),
  Menu(
    icon: "assets/icons/inventoryii.svg",
    title: "Inventaires",
  ),
  Menu(
    icon: "assets/icons/stock2.svg",
    title: "Stockage",
  ),
  Menu(
    icon: "assets/icons/users.svg",
    title: "Utilisateurs",
  ),
];
