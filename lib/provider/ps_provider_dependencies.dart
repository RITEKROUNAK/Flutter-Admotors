import 'package:flutteradmotors/db/about_us_dao.dart';
import 'package:flutteradmotors/db/blocked_user_dao.dart';
import 'package:flutteradmotors/db/bunner_dao.dart';
import 'package:flutteradmotors/db/chat_history_dao.dart';
import 'package:flutteradmotors/db/deal_option_dao.dart';
import 'package:flutteradmotors/db/follower_item_dao.dart';
import 'package:flutteradmotors/db/item_build_type_dao.dart';
import 'package:flutteradmotors/db/item_color_dao.dart';
import 'package:flutteradmotors/db/item_condition_dao.dart';
import 'package:flutteradmotors/db/item_currency_dao.dart';
import 'package:flutteradmotors/db/item_fuel_type_dao.dart';
import 'package:flutteradmotors/db/item_loacation_dao.dart';
import 'package:flutteradmotors/db/item_price_type_dao.dart';
import 'package:flutteradmotors/db/item_seller_dao.dart';
import 'package:flutteradmotors/db/item_type_dao.dart';
import 'package:flutteradmotors/db/manufacturer_dao.dart';
import 'package:flutteradmotors/db/model_dao.dart';
import 'package:flutteradmotors/db/offer_dao.dart';
import 'package:flutteradmotors/db/offline_payment_method_dao.dart';
import 'package:flutteradmotors/db/paid_ad_item_dao.dart';
import 'package:flutteradmotors/db/reported_item_dao.dart';
import 'package:flutteradmotors/db/transmission_dao.dart';
import 'package:flutteradmotors/db/user_map_dao.dart';
import 'package:flutteradmotors/db/user_unread_message_dao.dart';
import 'package:flutteradmotors/repository/about_us_repository.dart';
import 'package:flutteradmotors/repository/blocked_user_repository.dart';
import 'package:flutteradmotors/repository/bunner_repository.dart';
import 'package:flutteradmotors/repository/chat_history_repository.dart';
import 'package:flutteradmotors/repository/delete_task_repository.dart';
import 'package:flutteradmotors/repository/item_build_type_repository.dart';
import 'package:flutteradmotors/repository/item_color_repository.dart';
import 'package:flutteradmotors/repository/item_condition_repository.dart';
import 'package:flutteradmotors/repository/item_currency_repository.dart';
import 'package:flutteradmotors/repository/item_deal_option_repository.dart';
import 'package:flutteradmotors/repository/item_fuel_type_repository.dart';
import 'package:flutteradmotors/repository/item_location_repository.dart';
import 'package:flutteradmotors/repository/item_paid_history_repository.dart';
import 'package:flutteradmotors/repository/item_price_type_repository.dart';
import 'package:flutteradmotors/repository/item_seller_type_repository.dart';
import 'package:flutteradmotors/repository/item_type_repository.dart';
import 'package:flutteradmotors/repository/manufacturer_repository.dart';
import 'package:flutteradmotors/repository/model_repository.dart';
import 'package:flutteradmotors/repository/offer_repository.dart';
import 'package:flutteradmotors/repository/offline_payment_method_repository.dart';
import 'package:flutteradmotors/repository/paid_ad_item_repository.dart';
import 'package:flutteradmotors/db/favourite_product_dao.dart';
import 'package:flutteradmotors/db/gallery_dao.dart';
import 'package:flutteradmotors/db/history_dao.dart';
import 'package:flutteradmotors/db/rating_dao.dart';
import 'package:flutteradmotors/db/user_dao.dart';
import 'package:flutteradmotors/db/related_product_dao.dart';
import 'package:flutteradmotors/db/user_login_dao.dart';
import 'package:flutteradmotors/repository/Common/notification_repository.dart';
import 'package:flutteradmotors/repository/clear_all_data_repository.dart';
import 'package:flutteradmotors/repository/contact_us_repository.dart';
import 'package:flutteradmotors/repository/coupon_discount_repository.dart';
import 'package:flutteradmotors/repository/gallery_repository.dart';
import 'package:flutteradmotors/repository/history_repsitory.dart';
import 'package:flutteradmotors/db/blog_dao.dart';
import 'package:flutteradmotors/repository/blog_repository.dart';
import 'package:flutteradmotors/repository/rating_repository.dart';
import 'package:flutteradmotors/repository/reported_item_repository.dart';
import 'package:flutteradmotors/repository/token_repository.dart';
import 'package:flutteradmotors/repository/transmission_repository.dart';
import 'package:flutteradmotors/repository/user_repository.dart';
import 'package:flutteradmotors/repository/user_unread_message_repository.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/db/cateogry_dao.dart';
import 'package:flutteradmotors/db/common/ps_shared_preferences.dart';
import 'package:flutteradmotors/db/noti_dao.dart';
import 'package:flutteradmotors/db/product_dao.dart';
import 'package:flutteradmotors/db/product_map_dao.dart';
import 'package:flutteradmotors/repository/app_info_repository.dart';
import 'package:flutteradmotors/repository/language_repository.dart';
import 'package:flutteradmotors/repository/noti_repository.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/repository/ps_theme_repository.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = <SingleChildWidget>[
  ...independentProviders,
  ..._dependentProviders,
  ..._valueProviders,
];

List<SingleChildWidget> independentProviders = <SingleChildWidget>[
  Provider<PsSharedPreferences>.value(value: PsSharedPreferences.instance),
  Provider<PsApiService>.value(value: PsApiService()),
  Provider<CategoryDao>.value(value: CategoryDao()),
  Provider<ManufacturerDao>.value(value: ManufacturerDao()),
  Provider<TransmissionDao>.value(value: TransmissionDao()),
  Provider<ItemColorDao>.value(value: ItemColorDao()),
  Provider<ItemFuelTypeDao>.value(value: ItemFuelTypeDao()),
  Provider<ItemBuildTypeDao>.value(value: ItemBuildTypeDao()),
  Provider<ItemSellerTypeDao>.value(value: ItemSellerTypeDao()),
  Provider<UserMapDao>.value(value: UserMapDao.instance),
  Provider<ModelDao>.value(value: ModelDao()), //wrong type not contain instance
  Provider<ProductDao>.value(
      value: ProductDao.instance), //correct type with instance
  Provider<ProductMapDao>.value(value: ProductMapDao.instance),
  Provider<NotiDao>.value(value: NotiDao.instance),
  Provider<AboutUsDao>.value(value: AboutUsDao.instance),
  Provider<BlogDao>.value(value: BlogDao.instance),
  Provider<BunnerDao>.value(value: BunnerDao.instance),
  Provider<UserDao>.value(value: UserDao.instance),
  Provider<UserLoginDao>.value(value: UserLoginDao.instance),
  Provider<RelatedProductDao>.value(value: RelatedProductDao.instance),
  Provider<RatingDao>.value(value: RatingDao.instance),
  Provider<ItemLocationDao>.value(value: ItemLocationDao.instance),
  Provider<PaidAdItemDao>.value(value: PaidAdItemDao.instance),
  Provider<HistoryDao>.value(value: HistoryDao.instance),
  Provider<GalleryDao>.value(value: GalleryDao.instance),
  Provider<FavouriteProductDao>.value(value: FavouriteProductDao.instance),
  Provider<ChatHistoryDao>.value(value: ChatHistoryDao.instance),
  Provider<FollowerItemDao>.value(value: FollowerItemDao.instance),
  Provider<ItemTypeDao>.value(value: ItemTypeDao()),
  Provider<OfferDao>.value(value: OfferDao.instance),
  Provider<OfflinePaymentMethodDao>.value(value: OfflinePaymentMethodDao.instance),
  Provider<ItemConditionDao>.value(value: ItemConditionDao()),
  Provider<ItemPriceTypeDao>.value(value: ItemPriceTypeDao()),
  Provider<ItemCurrencyDao>.value(value: ItemCurrencyDao()),
  Provider<ItemDealOptionDao>.value(value: ItemDealOptionDao()),
  Provider<UserUnreadMessageDao>.value(value: UserUnreadMessageDao.instance),
  Provider<BlockedUserDao>.value(value: BlockedUserDao.instance),
  Provider<ReportedItemDao>.value(value: ReportedItemDao.instance),
];

List<SingleChildWidget> _dependentProviders = <SingleChildWidget>[
  ProxyProvider<PsSharedPreferences, PsThemeRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            PsThemeRepository psThemeRepository) =>
        PsThemeRepository(psSharedPreferences: ssSharedPreferences),
  ),
  ProxyProvider<PsApiService, AppInfoRepository>(
    update:
        (_, PsApiService psApiService, AppInfoRepository appInfoRepository) =>
            AppInfoRepository(psApiService: psApiService),
  ),
  ProxyProvider<PsSharedPreferences, LanguageRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            LanguageRepository languageRepository) =>
        LanguageRepository(psSharedPreferences: ssSharedPreferences),
  ),
  ProxyProvider<PsApiService, NotificationRepository>(
    update:
        (_, PsApiService psApiService, NotificationRepository userRepository) =>
            NotificationRepository(
      psApiService: psApiService,
    ),
  ),
  ProxyProvider<PsApiService, ItemPaidHistoryRepository>(
    update: (_, PsApiService psApiService,
            ItemPaidHistoryRepository itemPaidHistoryRepository) =>
        ItemPaidHistoryRepository(psApiService: psApiService),
  ),
  ProxyProvider2<PsApiService, CategoryDao, ClearAllDataRepository>(
    update: (_, PsApiService psApiService, CategoryDao categoryDao,
            ClearAllDataRepository clearAllDataRepository) =>
        ClearAllDataRepository(),
  ),
  ProxyProvider<PsApiService, DeleteTaskRepository>(
    update: (_, PsApiService psApiService,
            DeleteTaskRepository deleteTaskRepository) =>
        DeleteTaskRepository(),
  ),
  ProxyProvider<PsApiService, ContactUsRepository>(
    update: (_, PsApiService psApiService,
            ContactUsRepository apiStatusRepository) =>
        ContactUsRepository(psApiService: psApiService),
  ),
  ProxyProvider<PsApiService, CouponDiscountRepository>(
    update: (_, PsApiService psApiService,
            CouponDiscountRepository couponDiscountRepository) =>
        CouponDiscountRepository(psApiService: psApiService),
  ),
  ProxyProvider<PsApiService, TokenRepository>(
    update: (_, PsApiService psApiService, TokenRepository tokenRepository) =>
        TokenRepository(psApiService: psApiService),
  ),
  ProxyProvider2<PsApiService, ManufacturerDao, ManufacturerRepository>(
    update: (_, PsApiService psApiService, ManufacturerDao manufacturerDao,
            ManufacturerRepository manufacturerRepository2) =>
        ManufacturerRepository(
            psApiService: psApiService, manufacturerDao: manufacturerDao),
  ),
  ProxyProvider2<PsApiService, TransmissionDao, TransmissionRepository>(
    update: (_, PsApiService psApiService, TransmissionDao transmissionDao,
            TransmissionRepository manufacturerRepository2) =>
        TransmissionRepository(
            psApiService: psApiService, transmissionDao: transmissionDao),
  ),
  ProxyProvider2<PsApiService, ItemColorDao, ItemColorRepository>(
    update: (_, PsApiService psApiService, ItemColorDao itemColorDao,
            ItemColorRepository itemColorRepository2) =>
        ItemColorRepository(
            psApiService: psApiService, itemColorDao: itemColorDao),
  ),
  ProxyProvider2<PsApiService, OfferDao, OfferRepository>(
    update: (_, PsApiService psApiService, OfferDao offerDao,
            OfferRepository offerRepository) =>
        OfferRepository(psApiService: psApiService, offerDao: offerDao),
  ),
  ProxyProvider2<PsApiService, BlockedUserDao, BlockedUserRepository>(
    update: (_, PsApiService psApiService, BlockedUserDao blockedUserDao,
            BlockedUserRepository blockedUserRepository) =>
        BlockedUserRepository(psApiService: psApiService, blockedUserDao: blockedUserDao),
  ),
  ProxyProvider2<PsApiService, ReportedItemDao, ReportedItemRepository>(
    update: (_, PsApiService psApiService, ReportedItemDao reportedItemDao,
            ReportedItemRepository itemTypeRepository) =>
        ReportedItemRepository(
            psApiService: psApiService, reportedItemDao: reportedItemDao),
  ),
  ProxyProvider2<PsApiService, OfflinePaymentMethodDao, OfflinePaymentMethodRepository>(
    update: (_, PsApiService psApiService, OfflinePaymentMethodDao offlinePaymentMethodDao,
            OfflinePaymentMethodRepository categoryRepository2) =>
        OfflinePaymentMethodRepository(
            psApiService: psApiService, offlinePaymentMethodDao: offlinePaymentMethodDao),
  ),
  ProxyProvider2<PsApiService, ItemFuelTypeDao, ItemFuelTypeRepository>(
    update: (_, PsApiService psApiService, ItemFuelTypeDao itemFuelTypeDao,
            ItemFuelTypeRepository itemFuelTypeRepository2) =>
        ItemFuelTypeRepository(
            psApiService: psApiService, itemFuelTypeDao: itemFuelTypeDao),
  ),
  ProxyProvider2<PsApiService, ItemBuildTypeDao, ItemBuildTypeRepository>(
    update: (_, PsApiService psApiService, ItemBuildTypeDao itemBuildTypeDao,
            ItemBuildTypeRepository itemBuildTypeRepository2) =>
        ItemBuildTypeRepository(
            psApiService: psApiService, itemBuildTypeDao: itemBuildTypeDao),
  ),
  ProxyProvider2<PsApiService, ItemSellerTypeDao, ItemSellerTypeRepository>(
    update: (_, PsApiService psApiService, ItemSellerTypeDao itemSellerTypeDao,
            ItemSellerTypeRepository itemSellerTypeRepository2) =>
        ItemSellerTypeRepository(
            psApiService: psApiService, itemSellerTypeDao: itemSellerTypeDao),
  ),
  ProxyProvider2<PsApiService, ModelDao, ModelRepository>(
    update: (_, PsApiService psApiService, ModelDao modelDao,
            ModelRepository subCategoryRepository) =>
        ModelRepository(psApiService: psApiService, modelDao: modelDao),
  ),
  ProxyProvider2<PsApiService, ProductDao, ProductRepository>(
    update: (_, PsApiService psApiService, ProductDao productDao,
            ProductRepository categoryRepository2) =>
        ProductRepository(psApiService: psApiService, productDao: productDao),
  ),
  ProxyProvider2<PsApiService, NotiDao, NotiRepository>(
    update: (_, PsApiService psApiService, NotiDao notiDao,
            NotiRepository notiRepository) =>
        NotiRepository(psApiService: psApiService, notiDao: notiDao),
  ),
  ProxyProvider2<PsApiService, AboutUsDao, AboutUsRepository>(
    update: (_, PsApiService psApiService, AboutUsDao aboutUsDao,
            AboutUsRepository aboutUsRepository) =>
        AboutUsRepository(psApiService: psApiService, aboutUsDao: aboutUsDao),
  ),
  ProxyProvider2<PsApiService, BlogDao, BlogRepository>(
    update: (_, PsApiService psApiService, BlogDao blogDao,
            BlogRepository blogRepository) =>
        BlogRepository(psApiService: psApiService, blogDao: blogDao),
  ),
  ProxyProvider2<PsApiService, BunnerDao, BunnerRepository>(
    update: (_, PsApiService psApiService, BunnerDao bunnerDao,
            BunnerRepository bunnerRepository) =>
        BunnerRepository(psApiService: psApiService, bunnerDao: bunnerDao),
  ),
  ProxyProvider2<PsApiService, ItemLocationDao, ItemLocationRepository>(
    update: (_, PsApiService psApiService, ItemLocationDao itemLocationDao,
            ItemLocationRepository itemLocationRepository) =>
        ItemLocationRepository(
            psApiService: psApiService, itemLocationDao: itemLocationDao),
  ),
  ProxyProvider2<PsApiService, ItemTypeDao, ItemTypeRepository>(
    update: (_, PsApiService psApiService, ItemTypeDao itemTypeDao,
            ItemTypeRepository itemTypeRepository) =>
        ItemTypeRepository(
            psApiService: psApiService, itemTypeDao: itemTypeDao),
  ),
  ProxyProvider2<PsApiService, ItemConditionDao, ItemConditionRepository>(
    update: (_, PsApiService psApiService, ItemConditionDao itemConditionDao,
            ItemConditionRepository itemConditionRepository) =>
        ItemConditionRepository(
            psApiService: psApiService, itemConditionDao: itemConditionDao),
  ),
  ProxyProvider2<PsApiService, ItemPriceTypeDao, ItemPriceTypeRepository>(
    update: (_, PsApiService psApiService, ItemPriceTypeDao itemPriceTypeDao,
            ItemPriceTypeRepository itemPriceTypeRepository) =>
        ItemPriceTypeRepository(
            psApiService: psApiService, itemPriceTypeDao: itemPriceTypeDao),
  ),
  ProxyProvider2<PsApiService, ItemCurrencyDao, ItemCurrencyRepository>(
    update: (_, PsApiService psApiService, ItemCurrencyDao itemCurrencyDao,
            ItemCurrencyRepository itemCurrencyRepository) =>
        ItemCurrencyRepository(
            psApiService: psApiService, itemCurrencyDao: itemCurrencyDao),
  ),
  ProxyProvider2<PsApiService, ItemDealOptionDao, ItemDealOptionRepository>(
    update: (_, PsApiService psApiService, ItemDealOptionDao itemDealOptionDao,
            ItemDealOptionRepository itemCurrencyRepository) =>
        ItemDealOptionRepository(
            psApiService: psApiService, itemDealOptionDao: itemDealOptionDao),
  ),
  ProxyProvider2<PsApiService, ChatHistoryDao, ChatHistoryRepository>(
    update: (_, PsApiService psApiService, ChatHistoryDao chatHistoryDao,
            ChatHistoryRepository chatHistoryRepository) =>
        ChatHistoryRepository(
            psApiService: psApiService, chatHistoryDao: chatHistoryDao),
  ),
  ProxyProvider2<PsApiService, UserUnreadMessageDao,
      UserUnreadMessageRepository>(
    update: (_,
            PsApiService psApiService,
            UserUnreadMessageDao userUnreadMessageDao,
            UserUnreadMessageRepository userUnreadMessageRepository) =>
        UserUnreadMessageRepository(
            psApiService: psApiService,
            userUnreadMessageDao: userUnreadMessageDao),
  ),
  ProxyProvider2<PsApiService, RatingDao, RatingRepository>(
    update: (_, PsApiService psApiService, RatingDao ratingDao,
            RatingRepository ratingRepository) =>
        RatingRepository(psApiService: psApiService, ratingDao: ratingDao),
  ),
  ProxyProvider2<PsApiService, PaidAdItemDao, PaidAdItemRepository>(
    update: (_, PsApiService psApiService, PaidAdItemDao paidAdItemDao,
            PaidAdItemRepository paidAdItemRepository) =>
        PaidAdItemRepository(
            psApiService: psApiService, paidAdItemDao: paidAdItemDao),
  ),
  ProxyProvider2<PsApiService, HistoryDao, HistoryRepository>(
    update: (_, PsApiService psApiService, HistoryDao historyDao,
            HistoryRepository historyRepository) =>
        HistoryRepository(historyDao: historyDao),
  ),
  ProxyProvider2<PsApiService, GalleryDao, GalleryRepository>(
    update: (_, PsApiService psApiService, GalleryDao galleryDao,
            GalleryRepository galleryRepository) =>
        GalleryRepository(galleryDao: galleryDao, psApiService: psApiService),
  ),
  ProxyProvider3<PsApiService, UserDao, UserLoginDao, UserRepository>(
    update: (_, PsApiService psApiService, UserDao userDao,
            UserLoginDao userLoginDao, UserRepository userRepository) =>
        UserRepository(
            psApiService: psApiService,
            userDao: userDao,
            userLoginDao: userLoginDao),
  ),
];

List<SingleChildWidget> _valueProviders = <SingleChildWidget>[
  StreamProvider<PsValueHolder>(
    create: (BuildContext context) =>
        Provider.of<PsSharedPreferences>(context, listen: false).psValueHolder,
  )
];
