import {
  parallelize,
  createWorkflow,
  WorkflowResponse,
} from "@medusajs/framework/workflows-sdk";
import { sanityCategorySyncWorkflow } from "./sanity-sync-categories";
import { sanityCollectionSyncWorkflow } from "./sanity-sync-collections";
import { sanityProductSyncWorkflow } from "./sanity-sync-products";

type Input = {
  product_ids?: string[];
  collection_ids?: string[];
  category_ids?: string[];
  force?: boolean;
};

const id = "sanity-full-sync";

export const sanityFullSyncWorkflow: ReturnType<typeof createWorkflow> = createWorkflow(
  { name: id, retentionTime: 10000 },
  function (input: Input) {
    const products = sanityProductSyncWorkflow.runAsStep({
      input,
    });

    const collections = sanityCollectionSyncWorkflow.runAsStep({
      input,
    });

    const categories = sanityCategorySyncWorkflow.runAsStep({
      input,
    });

    return new WorkflowResponse({
      products,
      collections,
      categories,
    });
  },
);
