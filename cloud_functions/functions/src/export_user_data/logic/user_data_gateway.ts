import { firestore } from 'firebase-admin';
import { getMapItem } from '../../common';
import { SchulplanerReferences } from "../../schulplaner_globals";
import { UserId } from "../../user/models/user_id";
import { MapData } from "../../utils/map_converter";


export class UserDataGateway {

  constructor() { ; }

  async getRawData(userId: UserId): Promise<MapData<any>> {
    const references = SchulplanerReferences.getUsersDocument(userId);
    return this.getNestedData(references);
  }


  async getNestedData(documentReference: firestore.DocumentReference): Promise<MapData<any>> {
    const data = (await documentReference.get()).data();
    const subCollections = await documentReference.listCollections();
    const subCollectionsWithDocuments: MapData<MapData<any>[]> = {};
    for (const subCollection of subCollections) {
      const documents = await subCollection.listDocuments();
      const documentsOfSubCollection: MapData<any>[] = [];
      for (const document of documents) {
        const nestedData = await this.getNestedData(document);
        documentsOfSubCollection.push(nestedData);
      }
      subCollectionsWithDocuments[subCollection.id] = documentsOfSubCollection;
    }
    return getMapItem(documentReference.id, {
      'data': data,
      'subCollections': subCollectionsWithDocuments,
    });
  }
}