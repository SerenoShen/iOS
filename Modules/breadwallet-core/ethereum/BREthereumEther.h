#ifndef BR_Ethereum_Ether_H
#define BR_Ethereum_Ether_H

#include "rlp/BRRlp.h"
#include "util/BRUtil.h"
#include "BREthereumBase.h"

#ifdef __cplusplus
extern "C" {
#endif

//
// Ether
//
typedef enum {
    WEI = 0,

    KWEI = 1,
    ADA  = 1,

    MWEI = 2,

    GWEI    = 3,
    SHANNON = 3,

    SZABO = 4,

    FINNEY = 5,

    ETHER = 6,

    KETHER   = 7,
    GRAND    = 7,
    EINSTEIN = 7,

    METHER = 8,
    GETHER = 9,
    TETHER = 10
} BREthereumEtherUnit;

#define NUMBER_OF_ETHER_UNITS  (1 + TETHER)

typedef struct BREthereumEtherStruct {
    UInt256 valueInWEI;
} BREthereumEther;

extern BREthereumEther
etherCreateZero (void);

extern BREthereumEther
etherCreate(const UInt256 value);

extern BREthereumEther
etherCreateUnit(const UInt256 value, BREthereumEtherUnit unit, int *overflow);

extern BREthereumEther
etherCreateNumber (uint64_t number, BREthereumEtherUnit unit);

/**
 * Create Ether from a decimal string in unit.  The `number` must be either an integer or have
 * a single decimal point with at least one preceeding characters.  Thus: 0.001, 1.0000, 12
 * and 12.100 are all valid.  But .1 is invalid (required 0.1).
 *
 * @warn what happens if invalid
 *
 */
extern BREthereumEther
etherCreateString(const char *string, BREthereumEtherUnit unit, BRCoreParseStatus *status);

extern UInt256
etherGetValue(const BREthereumEther ether, BREthereumEtherUnit unit);

/**
 * Return a decimal string representing `ether` in `unit`.
 *
 * @param ether -
 * @param unit -
 *
 * @return A newly allocated string (you own it).
 */
extern char *
etherGetValueString(const BREthereumEther ether, BREthereumEtherUnit unit);

extern BRRlpItem
etherRlpEncode (const BREthereumEther ether, BRRlpCoder coder);

extern BREthereumEther
etherRlpDecode (BRRlpItem item, BRRlpCoder coder);
    
extern BREthereumEther
etherAdd (BREthereumEther e1, BREthereumEther e2, int *overflow);

extern BREthereumEther
etherSub (BREthereumEther e1, BREthereumEther e2, int *negative);

//
// Comparisons
//
extern BREthereumBoolean
etherIsEQ (BREthereumEther e1, BREthereumEther e2);

extern BREthereumBoolean
etherIsGT (BREthereumEther e1, BREthereumEther e2);

extern BREthereumBoolean
etherIsGE (BREthereumEther e1, BREthereumEther e2);

extern BREthereumBoolean
etherIsLT (BREthereumEther e1, BREthereumEther e2);

extern BREthereumBoolean
etherIsLE (BREthereumEther e1, BREthereumEther e2);

extern BREthereumBoolean
etherIsZero (BREthereumEther e);

extern BREthereumComparison
etherCompare (BREthereumEther e1, BREthereumEther e2);

#ifdef __cplusplus
}
#endif

#endif /* BR_Ethereum_Ether_H */

