/// Every dynamic link has an inofficial type. What does this mean?
/// When we get an dynamic link, we can distinguish which type of
/// dynamic link it is. If know this, we can call separate method. When
/// the link has the type [JOIN_BE_KEY], we know, that this is an joinLink.
export class DynamicLinksType {
    static JOIN_BY_KEY: string = 'joinbykey';
    static REFERRAL_PERSONAL: string = 'referral_personal';
}