import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shoe_care/app/enum/service_type.dart';
import 'package:shoe_care/data/repositories/auth_repository.dart';
import 'package:shoe_care/presentation/view/admin/mitra_profile_form.dart';
import 'package:shoe_care/presentation/view/admin/rekening_list_screen.dart';
import 'package:shoe_care/presentation/view/customer/detail_history_screen.dart';
import 'package:shoe_care/presentation/view/customer/history_screen.dart';
import 'package:shoe_care/presentation/view/edit_profile_screen.dart';
import 'package:shoe_care/presentation/view/login_screen.dart';
import 'package:shoe_care/presentation/view/customer/order_screen.dart';
import 'package:shoe_care/presentation/view/profile_screen.dart';
import 'package:shoe_care/presentation/view/welcoming_screen.dart';

// admin
import '../data/models/mitra_models.dart';
import '../data/models/user_profile_model.dart';
import '../presentation/view/admin/home_screen.dart' as admin;
import '../presentation/view/admin/services_screen.dart';
import 'package:shoe_care/presentation/view/admin/history_screen.dart' as admin;
import 'package:shoe_care/presentation/view/admin/detail_history_screen.dart'
    as admin;

import '../presentation/view/customer/home_screen.dart';
import '../presentation/view/customer/merchant_list_screen.dart';
import '../presentation/view/customer/order_detail_screen.dart';
import '../presentation/view/register_screen.dart';

final routeConfig = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: "/welcome",
      builder: (context, state) => const WelcomingScreen(),
      redirect: (context, state) async {
        final session = await AuthRepository().getSession();
        if (session != null) {
          if (session.role == "customer") {
            return '/customer';
          } else {
            return '/mitra';
          }
        }
        return null;
      },
    ),
    GoRoute(
      path: '/login-customer',
      builder: (context, state) => const LoginScreen(
        loginType: LoginType.customer,
      ),
    ),
    GoRoute(
      path: "/register",
      builder: (context, state) => const RegisterScreen(
        loginType: LoginType.customer,
      ),
    ),
    GoRoute(
      path: '/login-mitra',
      builder: (context, state) => const LoginScreen(
        loginType: LoginType.mitra,
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const MyProfileScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => EditProfileScreen(
        initialProfile: state.extra as UserProfile,
      ),
    ),
    GoRoute(
      path: '/mitra',
      builder: (context, state) => const admin.HomeScreen(),
      redirect: (context, state) async {
        final session = await AuthRepository().getSession();
        if (session != null) {
          if (session.role == "customer") {
            return '/customer';
          }
        } else {
          return '/welcome';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: 'services',
          pageBuilder: (context, state) {
            // slide animation
            return CustomTransitionPage(
              child: const ServicesScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'rekening',
          pageBuilder: (context, state) {
            // slide animation
            return CustomTransitionPage(
              child: const RekeningListScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'form',
          pageBuilder: (context, state) {
            // slide animation
            final initialData = state.extra as Mitra?;
            return CustomTransitionPage(
              child: MitraProfileForm(
                initialMitraProfile: initialData,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
            path: 'history-order',
            pageBuilder: (context, state) {
              // slide animation
              // final serviceType = state.extra as ServiceType;
              return CustomTransitionPage(
                child: const admin.HistoryScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              );
            },
            routes: [
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) {
                  // slide animation
                  return CustomTransitionPage(
                    child: const admin.DetailHistoryScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  );
                },
              ),
            ]),
      ],
    ),
    GoRoute(
      path: '/customer',
      builder: (context, state) => const HomeScreen(),
      redirect: (context, state) async {
        final session = await AuthRepository().getSession();
        if (session != null) {
          if (session.role == "mitra") {
            return '/mitra';
          }
        } else {
          return '/welcome';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: 'merchants',
          pageBuilder: (context, state) {
            // slide animation
            final serviceType = state.extra as ServiceType;
            return CustomTransitionPage(
              child: MerchanListScreen(serviceType: serviceType),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'make-order',
          pageBuilder: (context, state) {
            // slide animation
            final serviceType = state.extra as ServiceType;
            return CustomTransitionPage(
              child: const OrderScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'request-order',
          pageBuilder: (context, state) {
            // slide animation
            // final serviceType = state.extra as ServiceType;
            return CustomTransitionPage(
              child: const OrderDetailScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'history-order',
          pageBuilder: (context, state) {
            // slide animation
            // final serviceType = state.extra as ServiceType;
            return CustomTransitionPage(
              child: const HistoryScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
          routes: [
            GoRoute(
              path: ':id',
              pageBuilder: (context, state) {
                // slide animation
                return CustomTransitionPage(
                  child: const DetailHistoryScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/:id',
      pageBuilder: (context, state) {
        // slide animation
        return CustomTransitionPage(
          child: Container(
            color: Colors.white,
            child: const Center(
              child: Text('Page 2'),
            ),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
