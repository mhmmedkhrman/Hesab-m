import 'package:flutter/material.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/add_expense/add_expense.dart';
import '../presentation/budget_management/budget_management.dart';
import '../presentation/loans/loans.dart';
import '../presentation/add_income/add_income.dart';
import '../presentation/credit_cards/credit_cards.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String dashboardHome = '/dashboard-home';
  static const String addExpense = '/add-expense';
  static const String budgetManagement = '/budget-management';
  static const String loans = '/loans';
  static const String addIncome = '/add-income';
  static const String creditCards = '/credit-cards';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DashboardHome(),
    dashboardHome: (context) => const DashboardHome(),
    addExpense: (context) => const AddExpense(),
    budgetManagement: (context) => const BudgetManagement(),
    loans: (context) => const Loans(),
    addIncome: (context) => const AddIncome(),
    creditCards: (context) => const CreditCards(),
    // TODO: Add your other routes here
  };
}
