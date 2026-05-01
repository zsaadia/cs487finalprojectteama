import 'package:flutter/material.dart';
import 'dart:math' as math;

// ─── DATA MODELS ──────────────────────────────────────────────────────────────

class Stock {
  final String symbol;
  final String name;
  int quantity;
  final double currentPrice;
  final double percentChange;

  Stock({
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.currentPrice,
    required this.percentChange,
  });
}

class AutopayEntry {
  final String recipient;
  final double amount;
  final String frequency;
  bool isActive;

  AutopayEntry({
    required this.recipient,
    required this.amount,
    required this.frequency,
    this.isActive = true,
  });
}

// ─── APP ENTRY ────────────────────────────────────────────────────────────────

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Financial App Home Page'),
    );
  }
}

// ─── MAIN PAGE ────────────────────────────────────────────────────────────────

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedPage = 'home';
  double _balance = 12450.75;
  final double _lowBalanceThreshold = 1000.0;

  final List<Stock> _stocks = [
    Stock(symbol: 'AAPL', name: 'Apple Inc.', quantity: 50, currentPrice: 175.43, percentChange: 5.2),
    Stock(symbol: 'GOOGL', name: 'Alphabet Inc.', quantity: 25, currentPrice: 140.82, percentChange: -2.1),
    Stock(symbol: 'MSFT', name: 'Microsoft Corp.', quantity: 30, currentPrice: 380.15, percentChange: 8.7),
    Stock(symbol: 'TSLA', name: 'Tesla Inc.', quantity: 15, currentPrice: 242.50, percentChange: -3.5),
    Stock(symbol: 'AMZN', name: 'Amazon.com Inc.', quantity: 20, currentPrice: 180.25, percentChange: 12.3),
  ];

  final List<AutopayEntry> _autopayEntries = [
    AutopayEntry(recipient: 'Electric Company', amount: 120.00, frequency: 'Monthly'),
    AutopayEntry(recipient: 'Netflix', amount: 15.99, frequency: 'Monthly'),
    AutopayEntry(recipient: 'Gym Membership', amount: 45.00, frequency: 'Monthly'),
  ];

  void _selectPage(String page) => setState(() => _selectedPage = page);

  String _getPageTitle(String page) {
    switch (page) {
      case 'home': return 'Dashboard';
      case 'investments': return 'Investments';
      case 'alerts': return 'Alerts';
      case 'graphs': return 'Graphs';
      case 'autopay': return 'AutoPay';
      default: return 'Dashboard';
    }
  }

  Widget _buildPageContent() {
    switch (_selectedPage) {
      case 'home': return _buildHomePage();
      case 'investments': return _buildInvestmentsPage();
      case 'alerts': return _buildAlertsPage();
      case 'graphs': return _buildGraphsPage();
      case 'autopay': return _buildAutopayPage();
      default:
        return SizedBox.expand(
          child: Center(
            child: Text('${_getPageTitle(_selectedPage)} content coming soon',
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        );
    }
  }

  // ─── HOME ─────────────────────────────────────────────────────────────────

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoCard(label: 'Balance', value: '\$${_balance.toStringAsFixed(2)}', icon: Icons.wallet),
                    _buildInfoCard(label: 'Account Health', value: 'Excellent', icon: Icons.health_and_safety),
                    _buildInfoCard(label: 'Account ID', value: 'ACC-2847-6923', icon: Icons.badge),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Top Spending Categories', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                _buildSpendingCategory(category: 'Groceries', amount: '\$1,245.32', percentage: 35),
                const SizedBox(height: 12),
                _buildSpendingCategory(category: 'Utilities', amount: '\$892.50', percentage: 25),
                const SizedBox(height: 12),
                _buildSpendingCategory(category: 'Entertainment', amount: '\$654.18', percentage: 18),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active, color: Theme.of(context).colorScheme.error, size: 24),
                    const SizedBox(width: 12),
                    Text('Alert Center',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildAlert(title: 'Unusual Activity', message: 'Large purchase detected on 04/28', severity: 'warning'),
                const SizedBox(height: 12),
                _buildAlert(title: 'Bill Reminder', message: 'Your electric bill is due on 05/05', severity: 'info'),
                const SizedBox(height: 12),
                _buildAlert(title: 'Low Balance Alert', message: 'Your balance will fall below \$5,000 this month', severity: 'warning'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── INVESTMENTS ──────────────────────────────────────────────────────────

  Widget _buildInvestmentsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Your Stock Portfolio', style: Theme.of(context).textTheme.titleLarge),
            Tooltip(
              message: 'Coming soon',
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.add),
                label: const Text('Buy Other Stocks'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(child: _buildStockTable()),
          ),
        ),
      ],
    );
  }

  // ─── ALERTS ───────────────────────────────────────────────────────────────

  Widget _buildAlertsPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Security Alerts', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          if (_balance < _lowBalanceThreshold) ...[
            _buildAlertItem(
              title: 'Low Account Balance',
              description: 'Your account balance is below \$${_lowBalanceThreshold.toStringAsFixed(2)}. Current balance: \$${_balance.toStringAsFixed(2)}',
              severity: 'high', timestamp: 'Now',
              onApprove: () => _approveAlert(0), onDeny: () => _denyAlert(0),
            ),
            const SizedBox(height: 16),
          ],
          _buildAlertItem(
            title: 'Suspicious Activity Detected',
            description: 'Large purchase of \$5,250 detected on your account at 2:45 PM today.',
            severity: 'high', timestamp: 'Just now',
            onApprove: () => _approveAlert(1), onDeny: () => _denyAlert(1),
          ),
          const SizedBox(height: 16),
          _buildAlertItem(
            title: 'Unusual Location',
            description: 'Login attempt from a new location: New York, NY',
            severity: 'medium', timestamp: '2 hours ago',
            onApprove: () => _approveAlert(2), onDeny: () => _denyAlert(2),
          ),
          const SizedBox(height: 16),
          _buildAlertItem(
            title: 'Password Change',
            description: 'Your password was successfully changed.',
            severity: 'low', timestamp: '1 day ago',
            onApprove: () => _approveAlert(3), onDeny: () => _denyAlert(3),
          ),
        ],
      ),
    );
  }

  // ─── GRAPHS ───────────────────────────────────────────────────────────────

  Widget _buildGraphsPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Spending Trends', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Spending by Category', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Hover or tap a slice for details',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                      const SizedBox(height: 12),
                      const SizedBox(height: 240, child: InteractivePieChart()),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Spending Over Time', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Hover or tap a bar for details',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                      const SizedBox(height: 12),
                      const SizedBox(height: 240, child: InteractiveBarChart()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Monthly Breakdown', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Hover or tap a segment for details',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                      const SizedBox(height: 12),
                      const SizedBox(height: 220, child: InteractiveDonutChart()),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome,
                              color: Theme.of(context).colorScheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Text('AI Summary',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('This month you spent \$3,556.00 across all categories.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _buildSummaryPoint(Icons.trending_up,
                          'Your largest expense was Groceries at \$1,245.32 (35% of total spending).'),
                      const SizedBox(height: 8),
                      _buildSummaryPoint(Icons.warning_amber,
                          'Entertainment spending increased 18% compared to last month.'),
                      const SizedBox(height: 8),
                      _buildSummaryPoint(Icons.savings,
                          'You are on track to save \$2,100 this month based on current trends.'),
                      const SizedBox(height: 8),
                      _buildSummaryPoint(Icons.lightbulb_outline,
                          'Tip: Reducing dining out by 20% could save you ~\$130/month.'),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Refreshing AI insights...')),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh Insights'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPoint(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
      ],
    );
  }

  // ─── AUTOPAY ──────────────────────────────────────────────────────────────

  Widget _buildAutopayPage() {
    final monthlyTotal = _autopayEntries
        .where((e) => e.isActive && e.frequency == 'Monthly')
        .fold(0.0, (sum, e) => sum + e.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('AutoPay', style: Theme.of(context).textTheme.titleLarge),
            ElevatedButton.icon(
              onPressed: _showAddAutopayDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add AutoPay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAutopayStatCard('Active Payments',
                  _autopayEntries.where((e) => e.isActive).length.toString(),
                  Icons.check_circle, Colors.green),
              _buildAutopayStatCard('Monthly Total',
                  '\$${monthlyTotal.toStringAsFixed(2)}',
                  Icons.calendar_month, Theme.of(context).colorScheme.primary),
              _buildAutopayStatCard('Next Payment', 'May 5',
                  Icons.schedule, Colors.orange),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Scheduled Payments', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: _autopayEntries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final entry = _autopayEntries[index];
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: entry.isActive
                        ? Theme.of(context).colorScheme.outline
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: entry.isActive
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.autorenew,
                          color: entry.isActive
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.recipient,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: entry.isActive ? null : Colors.grey)),
                          Text(entry.frequency,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text('\$${entry.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: entry.isActive
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey)),
                    const SizedBox(width: 16),
                    Switch(
                      value: entry.isActive,
                      onChanged: (val) => setState(() => _autopayEntries[index].isActive = val),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        final name = entry.recipient;
                        setState(() => _autopayEntries.removeAt(index));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Removed $name autopay')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAutopayStatCard(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold, color: color)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  void _showAddAutopayDialog() {
    final recipientController = TextEditingController();
    final amountController = TextEditingController();
    String selectedFrequency = 'Monthly';
    bool canSubmit = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          void checkCanSubmit() {
            setDialogState(() {
              canSubmit = recipientController.text.trim().isNotEmpty &&
                  amountController.text.trim().isNotEmpty &&
                  double.tryParse(amountController.text.trim()) != null;
            });
          }

          return AlertDialog(
            title: const Text('Set Up AutoPay'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recipient', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: recipientController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Payee',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (_) => checkCanSubmit(),
                  ),
                  const SizedBox(height: 16),
                  Text('Payment Amount', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter Amount',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (_) => checkCanSubmit(),
                  ),
                  const SizedBox(height: 16),
                  Text('Frequency', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedFrequency,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: ['Weekly', 'Monthly', 'Quarterly', 'Yearly']
                        .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedFrequency = val);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: canSubmit ? () {
                  Navigator.pop(context);
                  _confirmAutopay(
                    recipientController.text.trim(),
                    double.parse(amountController.text.trim()),
                    selectedFrequency,
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Set AutoPay'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmAutopay(String recipient, double amount, String frequency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm AutoPay'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please confirm the following autopay setup:'),
            const SizedBox(height: 16),
            _buildConfirmRow('Recipient', recipient),
            const SizedBox(height: 8),
            _buildConfirmRow('Amount', '\$${amount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildConfirmRow('Frequency', frequency),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _autopayEntries.add(AutopayEntry(
                  recipient: recipient, amount: amount, frequency: frequency,
                ));
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('AutoPay set up for $recipient')),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  // ─── SHARED WIDGETS ───────────────────────────────────────────────────────

  Widget _buildInfoCard({required String label, required String value, required IconData icon}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSpendingCategory({required String category, required String amount, required int percentage}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category, style: Theme.of(context).textTheme.bodyMedium),
            Text(amount, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100, minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.outlineVariant,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(height: 4),
        Text('$percentage% of spending', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildAlert({required String title, required String message, required String severity}) {
    Color severityColor = severity == 'warning'
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white.withOpacity(0.7) : Colors.grey.shade900,
        border: Border.all(color: severityColor, width: 4),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(severity == 'warning' ? Icons.warning : Icons.info, color: severityColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem({
    required String title, required String description,
    required String severity, required String timestamp,
    required VoidCallback onApprove, required VoidCallback onDeny,
  }) {
    Color severityColor;
    IconData severityIcon;
    switch (severity) {
      case 'high': severityColor = Colors.red; severityIcon = Icons.error; break;
      case 'medium': severityColor = Colors.orange; severityIcon = Icons.warning; break;
      case 'low': severityColor = Colors.blue; severityIcon = Icons.info; break;
      default: severityColor = Colors.grey; severityIcon = Icons.info;
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: severityColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(severityIcon, color: severityColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(description, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(timestamp, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: onDeny,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Deny', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: onApprove,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Approve', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _approveAlert(int index) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alert approved')));
    setState(() {});
  }

  void _denyAlert(int index) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alert denied')));
    setState(() {});
  }

  Widget _buildStockTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Symbol')),
        DataColumn(label: Text('Company')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('Value')),
        DataColumn(label: Text('Change')),
        DataColumn(label: Text('Trend')),
        DataColumn(label: Text('Buy')),
        DataColumn(label: Text('Sell')),
      ],
      rows: _stocks.map((stock) {
        Color changeColor = stock.percentChange >= 0 ? Colors.green : Colors.red;
        IconData trendIcon = stock.percentChange >= 0 ? Icons.trending_up : Icons.trending_down;
        return DataRow(cells: [
          DataCell(Text(stock.symbol, style: const TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(stock.name)),
          DataCell(Text(stock.quantity.toString())),
          DataCell(Text('\$${(stock.quantity * stock.currentPrice).toStringAsFixed(2)}')),
          DataCell(Text(
            '${stock.percentChange >= 0 ? '+' : ''}${stock.percentChange.toStringAsFixed(1)}%',
            style: TextStyle(color: changeColor, fontWeight: FontWeight.bold),
          )),
          DataCell(Icon(trendIcon, color: changeColor)),
          DataCell(ElevatedButton(
            onPressed: () => _showBuySellDialog(stock, 'buy'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
            child: const Text('Buy', style: TextStyle(color: Colors.white)),
          )),
          DataCell(ElevatedButton(
            onPressed: () => _showBuySellDialog(stock, 'sell'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
            child: const Text('Sell', style: TextStyle(color: Colors.white)),
          )),
        ]);
      }).toList(),
    );
  }

  void _showBuySellDialog(Stock stock, String action) {
    int quantity = 1;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('${action == 'buy' ? 'Buy' : 'Sell'} ${stock.symbol}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current price: \$${stock.currentPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: quantity > 1 ? () => setDialogState(() => quantity--) : null,
                  ),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: TextEditingController(text: quantity.toString()),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        int? parsed = int.tryParse(value);
                        if (parsed != null && parsed > 0) setDialogState(() => quantity = parsed);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setDialogState(() => quantity++),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Total: \$${(quantity * stock.currentPrice).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                int stockIndex = _stocks.indexWhere((s) => s.symbol == stock.symbol);
                if (stockIndex != -1) {
                  double transactionAmount = quantity * stock.currentPrice;
                  if (action == 'buy') {
                    if (transactionAmount <= _balance) {
                      setState(() {
                        _stocks[stockIndex].quantity += quantity;
                        _balance -= transactionAmount;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Insufficient balance. Need \$${transactionAmount.toStringAsFixed(2)}')));
                      return;
                    }
                  } else {
                    if (quantity <= _stocks[stockIndex].quantity) {
                      setState(() {
                        _stocks[stockIndex].quantity -= quantity;
                        _balance += transactionAmount;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Cannot sell more than ${_stocks[stockIndex].quantity} shares')));
                      return;
                    }
                  }
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Successfully ${action == 'buy' ? 'bought' : 'sold'} $quantity shares of ${stock.symbol}')));
                Navigator.pop(context);
              },
              child: Text(action == 'buy' ? 'Buy' : 'Sell'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Container(
            width: 250,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Theme.of(context).colorScheme.primary,
                  child: Text('Applications',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                ),
                ListTile(leading: const Icon(Icons.dashboard), title: const Text('Dashboard'),
                    selected: _selectedPage == 'home', onTap: () => _selectPage('home')),
                ListTile(leading: const Icon(Icons.trending_up), title: const Text('Investments'),
                    selected: _selectedPage == 'investments', onTap: () => _selectPage('investments')),
                ListTile(leading: const Icon(Icons.notifications), title: const Text('Alerts'),
                    selected: _selectedPage == 'alerts', onTap: () => _selectPage('alerts')),
                ListTile(leading: const Icon(Icons.bar_chart), title: const Text('Graphs'),
                    selected: _selectedPage == 'graphs', onTap: () => _selectPage('graphs')),
                ListTile(leading: const Icon(Icons.autorenew), title: const Text('AutoPay'),
                    selected: _selectedPage == 'autopay', onTap: () => _selectPage('autopay')),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Main Content', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: _buildPageContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// INTERACTIVE CHART WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

// ─── SHARED TOOLTIP WIDGET ────────────────────────────────────────────────────

class ChartTooltip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Offset position;
  final Size chartSize;

  const ChartTooltip({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.position,
    required this.chartSize,
  });

  @override
  Widget build(BuildContext context) {
    const tooltipW = 140.0;
    const tooltipH = 54.0;
    const margin = 8.0;

    // Clamp so tooltip stays inside chart bounds
    double left = position.dx - tooltipW / 2;
    double top = position.dy - tooltipH - 12;
    left = left.clamp(margin, chartSize.width - tooltipW - margin);
    top = top.clamp(margin, chartSize.height - tooltipH - margin);

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: tooltipW,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade900.withOpacity(0.92),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(width: 10, height: 10,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Expanded(child: Text(label,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                    overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// ─── INTERACTIVE PIE CHART ────────────────────────────────────────────────────

class InteractivePieChart extends StatefulWidget {
  const InteractivePieChart({super.key});

  @override
  State<InteractivePieChart> createState() => _InteractivePieChartState();
}

class _InteractivePieChartState extends State<InteractivePieChart> {
  static const List<String> labels = ['Groceries', 'Utilities', 'Entertainment', 'Transport', 'Other'];
  static const List<double> values = [1245.32, 892.50, 654.18, 427.20, 336.80];
  static const List<Color> colors = [
    Color(0xFFE74C3C), Color(0xFFF39C12), Color(0xFF3498DB),
    Color(0xFF2ECC71), Color(0xFF9B59B6),
  ];

  int? _hoveredIndex;
  Offset? _tooltipPos;
  Size _chartSize = Size.zero;

  // Determine which pie slice contains the given local offset
  int? _sliceAt(Offset pos) {
    final center = Offset(_chartSize.width / 2, _chartSize.height / 2);
    final radius = math.min(_chartSize.width, _chartSize.height) / 2 - 8;
    final dx = pos.dx - center.dx;
    final dy = pos.dy - center.dy;
    final dist = math.sqrt(dx * dx + dy * dy);
    if (dist > radius) return null;

    double angle = math.atan2(dy, dx) + math.pi / 2; // offset so 0 is top
    if (angle < 0) angle += 2 * math.pi;

    final total = values.fold(0.0, (a, b) => a + b);
    double start = 0;
    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * math.pi;
      if (angle >= start && angle < start + sweep) return i;
      start += sweep;
    }
    return null;
  }

  void _handleInteraction(Offset localPos) {
    final idx = _sliceAt(localPos);
    setState(() {
      _hoveredIndex = idx;
      _tooltipPos = idx != null ? localPos : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = values.fold(0.0, (a, b) => a + b);
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            _chartSize = Size(constraints.maxWidth, constraints.maxHeight);
            return Stack(
              children: [
                // Hover (desktop/Chrome)
                MouseRegion(
                  onHover: (e) => _handleInteraction(e.localPosition),
                  onExit: (_) => setState(() {
                    _hoveredIndex = null;
                    _tooltipPos = null;
                  }),
                  // Tap (mobile)
                  child: GestureDetector(
                    onTapDown: (e) => _handleInteraction(e.localPosition),
                    onTapUp: (_) => Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() { _hoveredIndex = null; _tooltipPos = null; });
                    }),
                    child: CustomPaint(
                      size: _chartSize,
                      painter: _PieChartPainter(
                        values: values,
                        colors: colors,
                        hoveredIndex: _hoveredIndex,
                      ),
                    ),
                  ),
                ),
                if (_hoveredIndex != null && _tooltipPos != null)
                  ChartTooltip(
                    label: labels[_hoveredIndex!],
                    value: '\$${values[_hoveredIndex!].toStringAsFixed(2)} (${(values[_hoveredIndex!] / total * 100).toStringAsFixed(1)}%)',
                    color: colors[_hoveredIndex!],
                    position: _tooltipPos!,
                    chartSize: _chartSize,
                  ),
              ],
            );
          }),
        ),
        const SizedBox(height: 12),
        // Legend
        Wrap(
          spacing: 12, runSpacing: 6,
          children: List.generate(labels.length, (i) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 12, height: 12,
                  decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text('${labels[i]} ${(values[i] / total * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          )),
        ),
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final int? hoveredIndex;

  const _PieChartPainter({
    required this.values,
    required this.colors,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = math.min(size.width, size.height) / 2 - 8;
    double startAngle = -math.pi / 2;
    final total = values.fold(0.0, (a, b) => a + b);

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * math.pi;
      final isHovered = hoveredIndex == i;
      final radius = isHovered ? baseRadius + 8 : baseRadius;

      // Slightly offset hovered slice outward
      Offset sliceCenter = center;
      if (isHovered) {
        final midAngle = startAngle + sweepAngle / 2;
        sliceCenter = center + Offset(math.cos(midAngle) * 6, math.sin(midAngle) * 6);
      }

      canvas.drawArc(
        Rect.fromCircle(center: sliceCenter, radius: radius),
        startAngle, sweepAngle, true,
        Paint()..color = isHovered ? colors[i] : colors[i].withOpacity(0.85)
          ..style = PaintingStyle.fill,
      );
      canvas.drawArc(
        Rect.fromCircle(center: sliceCenter, radius: radius),
        startAngle, sweepAngle, true,
        Paint()..color = Colors.white..strokeWidth = 2..style = PaintingStyle.stroke,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(_PieChartPainter old) => old.hoveredIndex != hoveredIndex;
}

// ─── INTERACTIVE BAR CHART ────────────────────────────────────────────────────

class InteractiveBarChart extends StatefulWidget {
  const InteractiveBarChart({super.key});

  @override
  State<InteractiveBarChart> createState() => _InteractiveBarChartState();
}

class _InteractiveBarChartState extends State<InteractiveBarChart> {
  static const List<String> months = ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'];
  static const List<double> values = [2800, 3200, 2600, 3800, 3100, 3556];
  static const List<Color> barColors = [
    Color(0xFF85C1E9), Color(0xFF85C1E9), Color(0xFF85C1E9),
    Color(0xFFE74C3C), Color(0xFF85C1E9), Color(0xFF3498DB),
  ];

  int? _hoveredIndex;
  Offset? _tooltipPos;
  Size _chartSize = Size.zero;

  static const double _chartPaddingBottom = 24.0;
  static const double _chartPaddingLeft = 20.0;

  int? _barAt(Offset pos) {
    final chartHeight = _chartSize.height - _chartPaddingBottom;
    if (pos.dy > chartHeight) return null;
    final barWidth = (_chartSize.width - _chartPaddingLeft * 2) / values.length - 8;
    for (int i = 0; i < values.length; i++) {
      final left = _chartPaddingLeft + i * (barWidth + 8);
      if (pos.dx >= left && pos.dx <= left + barWidth) return i;
    }
    return null;
  }

  // Compute bar top for tooltip placement
  Offset _barTopCenter(int i) {
    final chartHeight = _chartSize.height - _chartPaddingBottom;
    final maxVal = values.reduce(math.max);
    final barWidth = (_chartSize.width - _chartPaddingLeft * 2) / values.length - 8;
    final barHeight = (values[i] / maxVal) * chartHeight;
    final left = _chartPaddingLeft + i * (barWidth + 8);
    return Offset(left + barWidth / 2, chartHeight - barHeight);
  }

  void _handleInteraction(Offset pos) {
    final idx = _barAt(pos);
    setState(() {
      _hoveredIndex = idx;
      _tooltipPos = idx != null ? _barTopCenter(idx) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _chartSize = Size(constraints.maxWidth, constraints.maxHeight);
      return Stack(
        children: [
          MouseRegion(
            onHover: (e) => _handleInteraction(e.localPosition),
            onExit: (_) => setState(() { _hoveredIndex = null; _tooltipPos = null; }),
            child: GestureDetector(
              onTapDown: (e) => _handleInteraction(e.localPosition),
              onTapUp: (_) => Future.delayed(const Duration(seconds: 2), () {
                if (mounted) setState(() { _hoveredIndex = null; _tooltipPos = null; });
              }),
              child: CustomPaint(
                size: _chartSize,
                painter: _BarChartPainter(
                  values: values,
                  months: months,
                  barColors: barColors,
                  hoveredIndex: _hoveredIndex,
                ),
              ),
            ),
          ),
          if (_hoveredIndex != null && _tooltipPos != null)
            ChartTooltip(
              label: months[_hoveredIndex!],
              value: '\$${values[_hoveredIndex!].toStringAsFixed(0)}',
              color: barColors[_hoveredIndex!],
              position: _tooltipPos!,
              chartSize: _chartSize,
            ),
        ],
      );
    });
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> months;
  final List<Color> barColors;
  final int? hoveredIndex;

  const _BarChartPainter({
    required this.values,
    required this.months,
    required this.barColors,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const paddingBottom = 24.0;
    const paddingLeft = 20.0;
    final maxVal = values.reduce(math.max);
    final barWidth = (size.width - paddingLeft * 2) / values.length - 8;
    final chartHeight = size.height - paddingBottom;

    // Gridlines
    final gridPaint = Paint()..color = Colors.grey.shade200..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = chartHeight - (chartHeight * i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (int i = 0; i < values.length; i++) {
      final barHeight = (values[i] / maxVal) * chartHeight;
      final left = paddingLeft + i * (barWidth + 8);
      final top = chartHeight - barHeight;
      final isHovered = hoveredIndex == i;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(left, top, barWidth, barHeight),
          topLeft: const Radius.circular(4), topRight: const Radius.circular(4),
        ),
        Paint()..color = isHovered
            ? barColors[i]
            : barColors[i].withOpacity(0.7),
      );

      // Highlight border on hover
      if (isHovered) {
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(left, top, barWidth, barHeight),
            topLeft: const Radius.circular(4), topRight: const Radius.circular(4),
          ),
          Paint()..color = Colors.white..strokeWidth = 2..style = PaintingStyle.stroke,
        );
      }

      // Month label
      final tp = TextPainter(
        text: TextSpan(
          text: months[i],
          style: TextStyle(
            color: isHovered ? Colors.black87 : Colors.grey,
            fontSize: 11,
            fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(left + barWidth / 2 - tp.width / 2, chartHeight + 6));
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) => old.hoveredIndex != hoveredIndex;
}

// ─── INTERACTIVE DONUT CHART ──────────────────────────────────────────────────

class InteractiveDonutChart extends StatefulWidget {
  const InteractiveDonutChart({super.key});

  @override
  State<InteractiveDonutChart> createState() => _InteractiveDonutChartState();
}

class _InteractiveDonutChartState extends State<InteractiveDonutChart> {
  static const List<String> labels = ['Fixed Bills', 'Variable', 'Savings'];
  static const List<double> values = [1200, 1556, 800];
  static const List<Color> colors = [Color(0xFF3498DB), Color(0xFFE74C3C), Color(0xFF2ECC71)];

  int? _hoveredIndex;
  Offset? _tooltipPos;
  Size _chartSize = Size.zero;

  int? _segmentAt(Offset pos) {
    final center = Offset(_chartSize.width / 2, _chartSize.height / 2);
    final outerRadius = math.min(_chartSize.width, _chartSize.height) / 2 - 8;
    final innerRadius = outerRadius * 0.55;
    final dx = pos.dx - center.dx;
    final dy = pos.dy - center.dy;
    final dist = math.sqrt(dx * dx + dy * dy);
    if (dist < innerRadius || dist > outerRadius) return null;

    double angle = math.atan2(dy, dx) + math.pi / 2;
    if (angle < 0) angle += 2 * math.pi;

    final total = values.fold(0.0, (a, b) => a + b);
    double start = 0;
    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * math.pi;
      if (angle >= start && angle < start + sweep) return i;
      start += sweep;
    }
    return null;
  }

  void _handleInteraction(Offset pos) {
    final idx = _segmentAt(pos);
    setState(() {
      _hoveredIndex = idx;
      _tooltipPos = idx != null ? pos : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = values.fold(0.0, (a, b) => a + b);
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            _chartSize = Size(constraints.maxWidth, constraints.maxHeight);
            return Stack(
              children: [
                MouseRegion(
                  onHover: (e) => _handleInteraction(e.localPosition),
                  onExit: (_) => setState(() { _hoveredIndex = null; _tooltipPos = null; }),
                  child: GestureDetector(
                    onTapDown: (e) => _handleInteraction(e.localPosition),
                    onTapUp: (_) => Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() { _hoveredIndex = null; _tooltipPos = null; });
                    }),
                    child: CustomPaint(
                      size: _chartSize,
                      painter: _DonutChartPainter(
                        values: values,
                        colors: colors,
                        hoveredIndex: _hoveredIndex,
                      ),
                    ),
                  ),
                ),
                if (_hoveredIndex != null && _tooltipPos != null)
                  ChartTooltip(
                    label: labels[_hoveredIndex!],
                    value: '\$${values[_hoveredIndex!].toStringAsFixed(2)} (${(values[_hoveredIndex!] / total * 100).toStringAsFixed(1)}%)',
                    color: colors[_hoveredIndex!],
                    position: _tooltipPos!,
                    chartSize: _chartSize,
                  ),
              ],
            );
          }),
        ),
        const SizedBox(height: 12),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(labels.length, (i) => Column(
            children: [
              Container(width: 14, height: 14,
                  decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle)),
              const SizedBox(height: 4),
              Text(labels[i], style: Theme.of(context).textTheme.bodySmall),
              Text('\$${values[i].toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          )),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final int? hoveredIndex;

  const _DonutChartPainter({
    required this.values,
    required this.colors,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = math.min(size.width, size.height) / 2 - 8;
    final innerRadius = outerRadius * 0.55;
    double startAngle = -math.pi / 2;
    final total = values.fold(0.0, (a, b) => a + b);
    final strokeWidth = outerRadius - innerRadius;
    final arcRadius = (outerRadius + innerRadius) / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * math.pi;
      final isHovered = hoveredIndex == i;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: isHovered ? arcRadius + 4 : arcRadius),
        startAngle, sweepAngle - 0.04, false,
        Paint()
          ..color = isHovered ? colors[i] : colors[i].withOpacity(0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isHovered ? strokeWidth + 6 : strokeWidth,
      );
      startAngle += sweepAngle;
    }

    // Center label — updates to show hovered segment or total
    final displayText = hoveredIndex != null
        ? '\$${values[hoveredIndex!].toStringAsFixed(0)}'
        : '\$${total.toStringAsFixed(0)}';
    final subText = hoveredIndex != null ? 'this month' : 'total';

    final tp = TextPainter(
      text: TextSpan(
        text: displayText,
        style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2 + 6));

    final subTp = TextPainter(
      text: TextSpan(
        text: subText,
        style: const TextStyle(color: Colors.grey, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    subTp.paint(canvas, center - Offset(subTp.width / 2, -tp.height / 2 + 2));
  }

  @override
  bool shouldRepaint(_DonutChartPainter old) => old.hoveredIndex != hoveredIndex;
}
