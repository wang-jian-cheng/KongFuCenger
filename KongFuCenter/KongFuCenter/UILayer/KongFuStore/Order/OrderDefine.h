//
//  OrderDefine.h
//  KongFuCenter
//
//  Created by Wangjc on 16/2/1.
//  Copyright © 2016年 zykj. All rights reserved.
//

#ifndef OrderDefine_h
#define OrderDefine_h
/**
 1：未付款 2：代发货 3：已发货 4：已签收 5：买家已评价 6：卖家已评价 7：已过期 8：全部 9:申请取消订单 10：已取消订单
 */
typedef enum _orderType
{
    OrderTypeNeedPay = 1,//1：未付款
    OrderTypeNeedSend,/*代发货*/
    OrderTypeAlreadySend,
    OrderTypeAlReadyReceive,
    OrderTypeBuyerAlReadyComment,
    OrderTypeSenderAlReadyComment,
    OrderTypeOrderPast,
    OrderTypeAll,
    OrderTypeApplyCancel,
    OrderTypeAlReadyCancel
    
}OrderType;





#endif /* OrderDefine_h */
