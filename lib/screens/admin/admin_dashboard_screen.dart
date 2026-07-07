import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/order_model.dart';
import '../../models/rider_model.dart';
import '../../models/staff_model.dart';
import '../../providers/admin_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _tab = 0;
  final _tabs = ['Overview', 'Orders', 'Staff', 'Reports'];
  final _icons = [Iconsax.chart_2, Iconsax.receipt_1, Iconsax.people, Iconsax.document_text];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('⚙️', style: TextStyle(fontSize: 16))),
            ),
            const SizedBox(width: 10),
            Text('Admin Dashboard',
                style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh, color: Colors.white70),
            onPressed: () => context.read<AdminProvider>().loadData(),
          ),
          IconButton(
            icon: const Icon(Iconsax.logout, color: Colors.white70),
            onPressed: () => context.go(RouteNames.adminLogin),
          ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, admin, _) {
          if (admin.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          return IndexedStack(
            index: _tab,
            children: [
              _OverviewTab(admin: admin),
              _OrdersTab(admin: admin),
              _StaffTab(admin: admin),
              _ReportsTab(admin: admin),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF16162A),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primary.withValues(alpha: 0.2),
          destinations: List.generate(4, (i) => NavigationDestination(
            icon: Icon(_icons[i], color: Colors.white38),
            selectedIcon: Icon(_icons[i], color: AppColors.primary),
            label: _tabs[i],
          )),
        ),
      ),
    );
  }
}

// ─────────────── OVERVIEW TAB ───────────────
class _OverviewTab extends StatelessWidget {
  final AdminProvider admin;
  const _OverviewTab({required this.admin});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: admin.loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 4),
          Text('Good ${_greeting()}! 👋',
              style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text("Here's what's happening today",
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white54)),
          const SizedBox(height: 20),
          // Stats grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _StatCard(label: "Today's Orders", value: '${admin.todayOrders}',
                  icon: Iconsax.receipt_1, color: AppColors.primary),
              _StatCard(label: "Today's Revenue", value: '৳${admin.todayRevenue.toInt()}',
                  icon: Iconsax.money, color: const Color(0xFF2ECC71)),
              _StatCard(label: 'Active Orders', value: '${admin.activeOrders}',
                  icon: Iconsax.clock, color: const Color(0xFFFFB627)),
              _StatCard(label: 'Active Riders', value: '${admin.activeRiders}',
                  icon: Iconsax.driving, color: const Color(0xFF5352ED)),
            ],
          ),
          const SizedBox(height: 24),
          // Order status breakdown
          _SectionTitle('Order Status Breakdown'),
          const SizedBox(height: 12),
          _StatusBreakdown(orders: admin.allOrders),
          const SizedBox(height: 24),
          _SectionTitle('Recent Orders'),
          const SizedBox(height: 12),
          ...admin.allOrders.take(5).map((o) => _OrderTile(order: o, dark: true)),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Morning';
    if (h < 17) return 'Afternoon';
    return 'Evening';
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: AppTextStyles.titleLarge
                      .copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
              Text(label,
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white54),
                  maxLines: 1),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBreakdown extends StatelessWidget {
  final List<OrderModel> orders;
  const _StatusBreakdown({required this.orders});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      ('Pending', OrderStatus.pending, AppColors.primary),
      ('Confirmed', OrderStatus.confirmed, const Color(0xFF70A1FF)),
      ('Preparing', OrderStatus.preparing, const Color(0xFFFFB627)),
      ('Picked Up', OrderStatus.pickedUp, const Color(0xFFFF9F43)),
      ('On the Way', OrderStatus.onTheWay, const Color(0xFF5352ED)),
      ('Delivered', OrderStatus.delivered, const Color(0xFF2ECC71)),
      ('Cancelled', OrderStatus.cancelled, AppColors.error),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: statuses.map((s) {
          final count = orders.where((o) => o.status == s.$2).length;
          final pct = orders.isEmpty ? 0.0 : count / orders.length;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(width: 10, height: 10,
                    decoration: BoxDecoration(color: s.$3, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                SizedBox(width: 80,
                    child: Text(s.$1,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white70))),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation(s.$3),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('$count',
                    style: AppTextStyles.labelSmall.copyWith(color: Colors.white54)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────── ORDERS TAB ───────────────
class _OrdersTab extends StatelessWidget {
  final AdminProvider admin;
  const _OrdersTab({required this.admin});

  static const _filters = ['All', 'Pending', 'Preparing', 'On the Way', 'Delivered', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips
        SizedBox(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _filters.length,
            itemBuilder: (_, i) {
              final selected = admin.orderFilter == _filters[i];
              return GestureDetector(
                onTap: () => admin.setOrderFilter(_filters[i]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : const Color(0xFF16162A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: selected ? AppColors.primary : Colors.white12),
                  ),
                  child: Text(_filters[i],
                      style: AppTextStyles.labelSmall.copyWith(
                          color: selected ? Colors.white : Colors.white54)),
                ),
              );
            },
          ),
        ),
        // Orders list
        Expanded(
          child: admin.filteredOrders.isEmpty
              ? Center(child: Text('No orders', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white38)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  itemCount: admin.filteredOrders.length,
                  itemBuilder: (_, i) => _OrderTile(order: admin.filteredOrders[i], dark: true, showActions: true),
                ),
        ),
      ],
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderModel order;
  final bool dark;
  final bool showActions;
  const _OrderTile({required this.order, required this.dark, this.showActions = false});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('#${order.id}',
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_statusLabel(order.status),
                    style: AppTextStyles.badge.copyWith(color: color)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.restaurantName,
              style: AppTextStyles.titleSmall.copyWith(color: Colors.white)),
          const SizedBox(height: 2),
          Text('${order.items.length} item(s)  •  ৳${order.total.toInt()}  •  ${order.paymentMethod}',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white54)),
          if (order.riderName != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Iconsax.driving, size: 14, color: Colors.white38),
                const SizedBox(width: 4),
                Text(order.riderName!,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white38)),
              ],
            ),
          ],
          if (showActions && _canChangeStatus(order.status)) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (order.status == OrderStatus.pending)
                  _ActionBtn('Mark Preparing', const Color(0xFFFFB627), () =>
                      context.read<AdminProvider>().updateOrderStatus(order.id, OrderStatus.preparing)),
                if (order.status == OrderStatus.preparing)
                  _ActionBtn('Assign Rider', const Color(0xFF5352ED), () =>
                      context.read<AdminProvider>().updateOrderStatus(order.id, OrderStatus.onTheWay)),
                if (order.status == OrderStatus.onTheWay)
                  _ActionBtn('Mark Delivered', const Color(0xFF2ECC71), () =>
                      context.read<AdminProvider>().updateOrderStatus(order.id, OrderStatus.delivered)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  bool _canChangeStatus(OrderStatus s) =>
      s != OrderStatus.delivered && s != OrderStatus.cancelled;

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending: return AppColors.primary;
      case OrderStatus.confirmed: return const Color(0xFF70A1FF);
      case OrderStatus.preparing: return const Color(0xFFFFB627);
      case OrderStatus.pickedUp: return const Color(0xFFFF9F43);
      case OrderStatus.onTheWay: return const Color(0xFF5352ED);
      case OrderStatus.delivered: return const Color(0xFF2ECC71);
      case OrderStatus.cancelled: return AppColors.error;
    }
  }

  String _statusLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.confirmed: return 'Confirmed';
      case OrderStatus.preparing: return 'Preparing';
      case OrderStatus.pickedUp: return 'Picked Up';
      case OrderStatus.onTheWay: return 'On the Way';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
      ),
    );
  }
}

// ─────────────── STAFF TAB ───────────────
class _StaffTab extends StatefulWidget {
  final AdminProvider admin;
  const _StaffTab({required this.admin});

  @override
  State<_StaffTab> createState() => _StaffTabState();
}

class _StaffTabState extends State<_StaffTab> with SingleTickerProviderStateMixin {
  late TabController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          decoration: BoxDecoration(
            color: const Color(0xFF16162A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _ctrl,
            tabs: const [Tab(text: '🛵  Riders'), Tab(text: '👨‍🍳  Kitchen')],
            labelStyle: AppTextStyles.labelMedium,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.white38,
            indicator: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            dividerColor: Colors.transparent,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _ctrl,
            children: [
              _RidersList(riders: widget.admin.riders),
              _KitchenList(staff: widget.admin.staff),
            ],
          ),
        ),
      ],
    );
  }
}

class _RidersList extends StatelessWidget {
  final List<RiderModel> riders;
  const _RidersList({required this.riders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: riders.length,
      itemBuilder: (_, i) {
        final r = riders[i];
        final color = r.status == RiderStatus.available
            ? const Color(0xFF2ECC71)
            : r.status == RiderStatus.onDelivery
                ? AppColors.primary
                : Colors.white38;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF16162A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(r.photo),
                    backgroundColor: Colors.white12,
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF16162A), width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name,
                        style: AppTextStyles.titleSmall.copyWith(color: Colors.white)),
                    Text('${r.vehicle}  •  ${r.area}',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white54)),
                    if (r.currentOrderAddress != null)
                      Text('→ ${r.currentOrderAddress}',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      r.status == RiderStatus.available ? 'Free'
                          : r.status == RiderStatus.onDelivery ? 'On Delivery'
                          : 'Offline',
                      style: AppTextStyles.badge.copyWith(color: color),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${r.todayDeliveries} today',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white38)),
                  Text('⭐ ${r.rating}',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white38)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KitchenList extends StatelessWidget {
  final List<StaffModel> staff;
  const _KitchenList({required this.staff});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: staff.length,
      itemBuilder: (_, i) {
        final s = staff[i];
        final color = s.status == StaffStatus.active
            ? const Color(0xFF2ECC71)
            : s.status == StaffStatus.onBreak
                ? const Color(0xFFFFB627)
                : Colors.white38;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF16162A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(s.photo),
                    backgroundColor: Colors.white12,
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF16162A), width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name,
                        style: AppTextStyles.titleSmall.copyWith(color: Colors.white)),
                    Text('${s.roleLabel}  •  Shift: ${s.shift}',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white54)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      s.status == StaffStatus.active ? 'Active'
                          : s.status == StaffStatus.onBreak ? 'On Break'
                          : 'Offline',
                      style: AppTextStyles.badge.copyWith(color: color),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${s.ordersToday} orders today',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white38)),
                  Text('⭐ ${s.rating}',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white38)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────── REPORTS TAB ───────────────
class _ReportsTab extends StatelessWidget {
  final AdminProvider admin;
  const _ReportsTab({required this.admin});

  @override
  Widget build(BuildContext context) {
    final sales = admin.weeklySales;
    final labels = admin.weekDayLabels;
    final maxSale = sales.reduce((a, b) => a > b ? a : b);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Sales Report',
                  style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
            ),
            GestureDetector(
              onTap: () => Share.share(admin.generateReport()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Iconsax.export, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text('Export', style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Summary cards
        Row(
          children: [
            Expanded(child: _MiniStat('Total Orders', '${admin.allOrders.length}', Iconsax.receipt_1)),
            const SizedBox(width: 10),
            Expanded(child: _MiniStat('Total Revenue', '৳${admin.totalRevenue.toInt()}', Iconsax.money)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _MiniStat('Avg Order', '৳${admin.allOrders.isEmpty ? 0 : (admin.totalRevenue / admin.allOrders.length).toInt()}', Iconsax.chart)),
            const SizedBox(width: 10),
            Expanded(child: _MiniStat('Delivered', '${admin.allOrders.where((o) => o.status == OrderStatus.delivered).length}', Iconsax.tick_circle)),
          ],
        ),
        const SizedBox(height: 24),
        Text('Last 7 Days Sales (৳)',
            style: AppTextStyles.titleSmall.copyWith(color: Colors.white70)),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
          decoration: BoxDecoration(
            color: const Color(0xFF16162A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: maxSale == 0
              ? Center(child: Text('No sales data', style: AppTextStyles.bodySmall.copyWith(color: Colors.white38)))
              : BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxSale * 1.3,
                    barGroups: List.generate(7, (i) => BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: sales[i],
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: 20,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        ),
                      ],
                    )),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) => Text(
                            labels[v.toInt()],
                            style: AppTextStyles.badge.copyWith(color: Colors.white38),
                          ),
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 44,
                          getTitlesWidget: (v, _) => Text(
                            v == 0 ? '' : '৳${v.toInt()}',
                            style: AppTextStyles.badge.copyWith(color: Colors.white38, fontSize: 9),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (_) => const FlLine(color: Colors.white10, strokeWidth: 1),
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
        ),
        const SizedBox(height: 24),
        Text('Payment Methods',
            style: AppTextStyles.titleSmall.copyWith(color: Colors.white70)),
        const SizedBox(height: 12),
        _PaymentBreakdown(orders: admin.allOrders),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _MiniStat(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: AppTextStyles.titleSmall
                        .copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                Text(label,
                    style: AppTextStyles.badge.copyWith(color: Colors.white38),
                    maxLines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentBreakdown extends StatelessWidget {
  final List<OrderModel> orders;
  const _PaymentBreakdown({required this.orders});

  @override
  Widget build(BuildContext context) {
    final methods = <String, int>{};
    for (final o in orders) {
      methods[o.paymentMethod] = (methods[o.paymentMethod] ?? 0) + 1;
    }
    final colors = [AppColors.primary, const Color(0xFF2ECC71), const Color(0xFFFFB627), const Color(0xFF5352ED)];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: methods.entries.toList().asMap().entries.map((e) {
          final color = colors[e.key % colors.length];
          final pct = orders.isEmpty ? 0.0 : e.value.value / orders.length;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                SizedBox(width: 120, child: Text(e.value.key, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70))),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct, backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation(color), minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${e.value.value}', style: AppTextStyles.labelSmall.copyWith(color: Colors.white54)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Helpers ───────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Text(title,
      style: AppTextStyles.titleSmall.copyWith(color: Colors.white70));
}
