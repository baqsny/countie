class Strings {
  //ngrok http https://localhost:8080 -host-header="localhost:8080"
  static String baseUrl = 'https://2db7-87-205-165-118.ngrok.io';
  //static String baseUrl = 'https://countie.pl';
  static String getAllProceduresUrl = baseUrl + '/katalog';
  static String getAllCategoriesUrl = getAllProceduresUrl + '/kategorie';
  static String planner_url = baseUrl + '/app/planner/';
  static String summary_url = baseUrl + '/app/summary/';
  static String login_user = baseUrl + '/app/login';
  static String register_user = baseUrl + '/app/register';
}
