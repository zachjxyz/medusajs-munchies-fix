import type {StoreProductVariant} from "@medusajs/types";

export type AddToCartEventPayload = {
  productVariant: StoreProductVariant;
  regionId: string;
};

type CartAddEventHandler = (payload: AddToCartEventPayload) => void;

type CartAddEventBus = {
  emitCartAdd: (payload: AddToCartEventPayload) => void;
  handler: CartAddEventHandler;
  registerCartAddHandler: (handler: CartAddEventHandler) => void;
};

export const addToCartEventBus: CartAddEventBus = {
  emitCartAdd(payload: AddToCartEventPayload) {
    this.handler(payload);
  },

  handler: () => {},

  registerCartAddHandler(handler: CartAddEventHandler) {
    this.handler = handler;
  },
};
