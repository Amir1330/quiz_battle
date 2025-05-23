import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/connectivity_provider.dart';
import '../providers/sync_provider.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ConnectivityProvider, SyncProvider>(
      builder: (context, connectivity, sync, _) {
        if (connectivity.isOnline) {
          return const SizedBox.shrink();
        }

        return Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.cloud_off, color: Colors.white),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'You are offline',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (sync.lastSyncError != null)
                IconButton(
                  icon: const Icon(Icons.sync_problem, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sync error: ${sync.lastSyncError}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),
              IconButton(
                icon: sync.isSyncing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.sync, color: Colors.white),
                onPressed: sync.isSyncing ? null : () => sync.syncData(),
              ),
            ],
          ),
        );
      },
    );
  }
} 